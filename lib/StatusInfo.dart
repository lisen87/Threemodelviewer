/// Created by robot on 2022/3/29 12:27.
/// @author robot < robot >

class StatusInfo{
  ///onStart onProgress,onLoad,onLoadComplete, onLoadError
  String? status;
  String? info;

  StatusInfo({this.status, this.info});
}
enum Status {
  onStart,
  onProgress,
  onLoad,
  onLoadComplete,
  onLoadError,
}