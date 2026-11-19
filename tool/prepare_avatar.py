"""Prepare the Android avatar demo."""

import argparse
import hashlib
import io
import json
from pathlib import Path
from shutil import copytree
from subprocess import run
import tarfile
from urllib.request import urlopen
from zipfile import ZipFile


SOURCE = (
    "https://raw.githubusercontent.com/Live2D/CubismWebSamples/"
    "b1de66b0b1f1cb881d95fb6158622aeb6a2827bd/Samples/Resources/Hiyori/"
)
ROOT = Path(__file__).resolve().parents[1]
DESTINATION = ROOT / "assets/avatar/hiyori"
WANKO_RUNTIME = ROOT / "assets/wanko_ja/runtime"
AVATAR_DEFAULTS = ROOT / "lib/application/avatar_defaults.dart"
PLUGIN = ROOT / ".avatar_sdk/live2d_flutter"
PLUGIN_URL = "https://pub.dev/api/archives/live2d_flutter-1.0.3.tar.gz"
PLUGIN_SHA256 = "b16d5d861661427609a692e311f469941526d33a32912616191b8ca5efc84332"
PLUGIN_PATCH = "android-3"


def prepare_defaults():
    if not AVATAR_DEFAULTS.exists():
        AVATAR_DEFAULTS.write_text(
            "const defaultAvatarEndpoint = '';\nconst defaultAvatarToken = '';\n",
            encoding="utf-8",
        )


def prepare_plugin(local_archive):
    marker = PLUGIN / f".prepared-{PLUGIN_PATCH}"
    if local_archive is None and marker.is_file():
        return
    if local_archive is None:
        with urlopen(PLUGIN_URL, timeout=60) as response:
            data = response.read()
    else:
        data = local_archive.read_bytes()
    if hashlib.sha256(data).hexdigest() != PLUGIN_SHA256:
        raise ValueError("live2d_flutter archive checksum mismatch")
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
        for entry in archive:
            if not entry.isfile():
                continue
            name = Path(entry.name)
            if name.is_absolute() or ".." in name.parts:
                raise ValueError("Unexpected live2d_flutter archive path")
            if name.parts[0] not in {"android", "lib", "LICENSE", "NOTICES", "pubspec.yaml"}:
                continue
            target = PLUGIN / name
            target.parent.mkdir(parents=True, exist_ok=True)
            with archive.extractfile(entry) as source:
                target.write_bytes(source.read())
    pubspec = PLUGIN / "pubspec.yaml"
    # 1.0.3 declares Web assets that are missing from the published archive.
    header = pubspec.read_text(encoding="utf-8").split("\nflutter:\n", 1)[0]
    pubspec.write_text(
        header + "\nflutter:\n"
        "  plugin:\n"
        "    platforms:\n"
        "      android:\n"
        "        package: com.linh18nd.flutter_live2d\n"
        "        pluginClass: FlutterLive2dPlugin\n",
        encoding="utf-8",
    )
    patch_android_plugin()
    marker.touch()


def patch_android_plugin():
    main = PLUGIN / "android/src/main"
    shaders = main / "cpp/CubismFramework/Rendering/OpenGL/Shaders/StandardES"
    copytree(shaders, main / "assets/FrameworkShaders", dirs_exist_ok=True)
    # The renderer queues commands until EGL is ready and compiles extended
    # blend shaders only if the model uses them.
    patch = ROOT / "tool/live2d_flutter_android.patch"
    run(["patch", "-p1", "--batch", "--forward", "-i", str(patch)], cwd=PLUGIN, check=True)


def read_asset(name, source_dir):
    if source_dir is not None:
        return (source_dir / name).read_bytes()
    with urlopen(SOURCE + name, timeout=30) as response:
        return response.read()


def expression(parameters, fade):
    return {
        "Type": "Live2D Expression",
        "FadeInTime": fade,
        "FadeOutTime": fade,
        "Parameters": [
            {"Id": name, "Value": value, "Blend": blend}
            for name, value, blend in parameters
        ],
    }


def prepare(source_dir):
    model = json.loads(read_asset("Hiyori.model3.json", source_dir))
    references = model["FileReferences"]
    DESTINATION.mkdir(parents=True, exist_ok=True)

    def copy_asset(name):
        filename = Path(name).name
        (DESTINATION / filename).write_bytes(read_asset(name, source_dir))
        return filename

    for key in ("Moc", "Physics", "Pose", "UserData", "DisplayInfo"):
        references[key] = copy_asset(references[key])
    references["Textures"] = [copy_asset(name) for name in references["Textures"]]
    idle = references["Motions"]["Idle"][0]
    idle["File"] = copy_asset(idle["File"])
    references["Motions"] = {"Idle": [idle]}

    # The Android renderer restores motion parameters every frame. Expressions
    # apply the app's mouth and pose parameters after those motion updates.
    poses = {
        "idle": expression([("ParamMouthOpenY", 0, "Overwrite")], 0.18),
        "listening": expression([
            ("ParamMouthOpenY", 0, "Overwrite"),
            ("ParamAngleY", -6, "Add"),
            ("ParamAngleZ", 7, "Add"),
        ], 0.18),
        "thinking": expression([
            ("ParamMouthOpenY", 0, "Overwrite"),
            ("ParamAngleX", 8, "Add"),
            ("ParamEyeBallY", 0.45, "Add"),
        ], 0.18),
    }
    for step in range(9):
        poses[f"speaking_{step}"] = expression([
            ("ParamMouthOpenY", step / 8, "Overwrite"),
            ("ParamMouthForm", 0.65, "Overwrite"),
        ], 0)

    references["Expressions"] = []
    for name, data in poses.items():
        filename = f"{name}.exp3.json"
        (DESTINATION / filename).write_text(json.dumps(data), encoding="utf-8")
        references["Expressions"].append({"Name": name, "File": filename})
    (DESTINATION / "Avatar.model3.json").write_text(
        json.dumps(model, indent=2) + "\n", encoding="utf-8"
    )


def prepare_wanko(local_archive):
    model = json.loads((WANKO_RUNTIME / "VoxWanko.model3.json").read_text(encoding="utf-8"))
    references = model["FileReferences"]
    files = [references[key] for key in ("Moc", "Physics", "DisplayInfo")]
    files.extend(references["Textures"])
    files.extend(motion["File"] for group in references["Motions"].values() for motion in group)
    missing = [name for name in files if not (WANKO_RUNTIME / name).is_file()]
    if not missing:
        return
    if local_archive is None:
        raise SystemExit("Pass the official Wanko ZIP with --wanko-archive")
    with ZipFile(local_archive) as archive:
        for name in missing:
            target = WANKO_RUNTIME / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(archive.read(f"runtime/{name}"))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir", type=Path, help="Use a local Hiyori sample folder.")
    parser.add_argument("--plugin-archive", type=Path, help="Use a local pub.dev archive.")
    parser.add_argument("--wanko-archive", type=Path, help="Use the official Wanko ZIP.")
    parser.add_argument("--plugin-only", action="store_true")
    args = parser.parse_args()
    prepare_defaults()
    prepare_plugin(args.plugin_archive)
    if args.plugin_only:
        (WANKO_RUNTIME / "motion").mkdir(parents=True, exist_ok=True)
        (WANKO_RUNTIME / "wanko_touch.1024").mkdir(parents=True, exist_ok=True)
    else:
        prepare_wanko(args.wanko_archive)
        prepare(args.source_dir)
        print(f"Prepared Hiyori in {DESTINATION}")
