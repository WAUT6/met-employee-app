import 'dart:io';

abstract class IoState {
  const IoState();
}

class IoStateInitialized extends IoState {
  const IoStateInitialized();
}

class IoStateDownloadingPdf extends IoState {
  const IoStateDownloadingPdf();
}

class IoStateAwaitingUserSelection extends IoState {
  final File pdf;
  const IoStateAwaitingUserSelection({
    required this.pdf,
  });
}
