import 'package:flutter/material.dart';
import 'package:testsendbird/utils/helper.dart';
import 'package:testsendbird/utils/theme.dart';

class BubbleReceiver extends StatelessWidget {
  final String? userName;
  final String? avatarUrl;
  final bool? onlineStatus;
  final String? message;
  final int? createdAt;

  const BubbleReceiver({
    super.key,
    this.userName,
    this.avatarUrl,
    this.onlineStatus,
    this.message,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircleAvatar(
                  backgroundImage: (avatarUrl?.isNotEmpty ?? false) ? NetworkImage(avatarUrl ?? '') : null,
                  backgroundColor: CustomTheme.generateColor(),
                  radius: 16,
                  child: (avatarUrl?.isNotEmpty ?? false)
                      ? null
                      : CircleAvatar(
                          radius: 15,
                          backgroundColor: CustomTheme.dark7,
                          child: Center(
                            child: Text(userName?.toUpperCase().substring(0, 1) ?? ''),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: ShapeDecoration(
                    color: CustomTheme.dark5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              userName ?? 'Anonymous',
                              style: TextStyle(
                                color: CustomTheme.dark2,
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          onlineStatus ?? false
                              ? Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.statusActive,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                )
                              : Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(
                                    gradient: CustomTheme.statusInactive,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 0.2),
          child: Text(
            Timeago().getTimeago(createdAt),
            style: TextStyle(fontSize: 12.0, color: CustomTheme.dark1),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class BubbleSender extends StatelessWidget {
  final String? userName;
  final bool? onlineStatus;
  final String? message;

  const BubbleSender({
    super.key,
    this.userName,
    this.onlineStatus,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: ShapeDecoration(
              gradient: CustomTheme.bgChatSender,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            child: Text(
              message ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
