import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'provider_dto.dart';
part 'provider_api.g.dart';

@RestApi()
abstract class ProviderApi {
  factory ProviderApi(Dio dio, {String? baseUrl}) = _ProviderApi;
  @GET('models')
  Future<ModelListDto> models(
    @Header('Authorization') String authorization,
    @CancelRequest() CancelToken cancelToken,
  );
  @POST('chat/completions')
  Future<CompletionDto> complete(
    @Header('Authorization') String authorization,
    @Body() CompletionRequest request,
    @CancelRequest() CancelToken cancelToken,
  );
}
