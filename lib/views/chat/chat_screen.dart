import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:testsendbird/utils/theme.dart';
import 'package:testsendbird/views/chat/widgets/chat_bubble.dart';
import 'package:testsendbird/views/chat/widgets/input_message.dart';

class OpenChannelPage extends StatefulWidget {
  const OpenChannelPage({super.key});

  @override
  State<OpenChannelPage> createState() => OpenChannelPageState();
}

class OpenChannelPageState extends State<OpenChannelPage> {
  final channelUrl = Get.parameters['channel_url']!;
  final itemScrollController = ItemScrollController();
  final textEditingController = TextEditingController();
  late PreviousMessageListQuery query;

  String title = '';
  bool hasPrevious = false;
  List<BaseMessage> messageList = [];
  int? participantCount;

  OpenChannel? openChannel;

  @override
  void initState() {
    super.initState();
    SendbirdChat.addChannelHandler('OpenChannel', MyOpenChannelHandler(this));
    SendbirdChat.addConnectionHandler('OpenChannel', MyConnectionHandler(this));
    debugPrint('CHANNEL_URL: $channelUrl');

    OpenChannel.getChannel(channelUrl).then((openChannel) {
      this.openChannel = openChannel;
      openChannel.enter().then((_) => _initialize());
    });
  }

  void _initialize() {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      query = PreviousMessageListQuery(
        channelType: ChannelType.open,
        channelUrl: channelUrl,
      )..next().then((messages) {
          setState(() {
            messageList
              ..clear()
              ..addAll(messages);
            title = openChannel.name;
            hasPrevious = query.hasNext;
            participantCount = openChannel.participantCount;
          });
        });
    });
  }

  @override
  void dispose() {
    SendbirdChat.removeChannelHandler('OpenChannel');
    SendbirdChat.removeConnectionHandler('OpenChannel');
    textEditingController.dispose();

    OpenChannel.getChannel(channelUrl).then((channel) => channel.exit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: 2,
          ),
          actions: const [],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  messageList.isNotEmpty ? _list() : Container(),
                  hasPrevious ? _previousButton() : Container(),
                ],
              ),
            ),
            _messageSender(),
          ],
        ),
      ),
    );
  }

  Widget _previousButton() {
    return Container(
      width: double.maxFinite,
      height: 32.0,
      color: CustomTheme.bgChatReciver.withOpacity(0.3),
      child: IconButton(
        icon: const Icon(Icons.expand_less, size: 16.0),
        color: Colors.white,
        style: IconButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () async {
          if (query.hasNext && !query.isLoading) {
            final messages = await query.next();
            final openChannel = await OpenChannel.getChannel(channelUrl);
            setState(() {
              messageList.insertAll(0, messages);
              title = '${openChannel.name} (${messageList.length})';
              hasPrevious = query.hasNext;
            });
            _scroll(0);
          }
        },
      ),
    );
  }

  Widget _list() {
    return ScrollablePositionedList.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      physics: const ClampingScrollPhysics(),
      initialScrollIndex: messageList.length - 1,
      itemScrollController: itemScrollController,
      itemCount: messageList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= messageList.length) return Container();

        BaseMessage message = messageList[index];

        return GestureDetector(
          onDoubleTap: () async {
            // final openChannel = await OpenChannel.getChannel(channelUrl);
            // Get.toNamed('/message/update/${openChannel.channelType.toString()}/${openChannel.channelUrl}/${message.messageId}')?.then((message) async {
            //   if (message != null) {
            //     for (int index = 0; index < messageList.length; index++) {
            //       if (messageList[index].messageId == message.messageId) {
            //         setState(() => messageList[index] = message);
            //         break;
            //       }
            //     }
            //   }
            // });
          },
          onLongPress: () async {
            // final openChannel = await OpenChannel.getChannel(channelUrl);
            // await openChannel.deleteMessage(message.messageId);
            // setState(() {
            //   messageList.remove(message);
            //   title = '${openChannel.name} (${messageList.length})';
            // });
          },
          child: Column(
            children: [
              (message.sender?.userId != SendbirdChat.currentUser?.userId)
                  ? BubbleReceiver(
                      userName: message.sender?.userId,
                      onlineStatus: message.sender?.isActive ?? false,
                      message: message.message,
                      createdAt: message.createdAt,
                      avatarUrl: message.sender?.profileUrl ?? '',
                    )
                  : BubbleSender(
                      userName: message.sender?.userId,
                      onlineStatus: message.sender?.isActive ?? false,
                      message: message.message,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _messageSender() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Get.isDarkMode ? CustomTheme.dark6 : CustomTheme.white,
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              Get.isDarkMode ? 'assets/icons/plus.svg' : 'assets/icons/plus_dark.svg',
              colorFilter: ColorFilter.mode(Get.isDarkMode ? CustomTheme.dark0 : CustomTheme.dark4, BlendMode.dstIn),
            ),
          ),
          Expanded(
            child: InputMessage(
              textEditingController,
              onSend: () {
                if (textEditingController.value.text.isEmpty) {
                  return;
                }

                openChannel?.sendUserMessage(
                  UserMessageCreateParams(
                    message: textEditingController.value.text,
                  ),
                  handler: (UserMessage message, SendbirdException? e) async {
                    if (e != null) {
                      await _showDialogToResendUserMessage(message);
                    } else {
                      _addMessage(message);
                    }
                  },
                );

                textEditingController.clear();
              },
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Future<void> _showDialogToResendUserMessage(UserMessage message) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text('Resend: ${message.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  openChannel?.resendUserMessage(
                    message,
                    handler: (message, e) async {
                      if (e != null) {
                        await _showDialogToResendUserMessage(message);
                      } else {
                        _addMessage(message);
                      }
                    },
                  );

                  Get.back();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('No'),
              ),
            ],
          );
        });
  }

  void _addMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        messageList.add(message);
        title = '${openChannel.name} (${messageList.length})';
        participantCount = openChannel.participantCount;
      });

      Future.delayed(
        const Duration(milliseconds: 100),
        () => _scroll(messageList.length - 1),
      );
    });
  }

  void _updateMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        for (int index = 0; index < messageList.length; index++) {
          if (messageList[index].messageId == message.messageId) {
            messageList[index] = message;
            break;
          }
        }

        title = '${openChannel.name} (${messageList.length})';
        participantCount = openChannel.participantCount;
      });
    });
  }

  void _deleteMessage(int messageId) {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        for (int index = 0; index < messageList.length; index++) {
          if (messageList[index].messageId == messageId) {
            messageList.removeAt(index);
            break;
          }
        }

        title = '${openChannel.name} (${messageList.length})';
        participantCount = openChannel.participantCount;
      });
    });
  }

  void _updateParticipantCount() {
    OpenChannel.getChannel(channelUrl).then((openChannel) {
      setState(() {
        participantCount = openChannel.participantCount;
      });
    });
  }

  void _scroll(int index) async {
    if (messageList.length <= 1) return;

    while (!itemScrollController.isAttached) {
      await Future.delayed(const Duration(milliseconds: 1));
    }

    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }
}

class MyOpenChannelHandler extends OpenChannelHandler {
  final OpenChannelPageState _state;

  MyOpenChannelHandler(this._state);

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    debugPrint('MESSAGE: ${message.toJson()}');
    _state._addMessage(message);
  }

  @override
  void onMessageUpdated(BaseChannel channel, BaseMessage message) {
    _state._updateMessage(message);
  }

  @override
  void onMessageDeleted(BaseChannel channel, int messageId) {
    _state._deleteMessage(messageId);
  }

  @override
  void onUserEntered(OpenChannel channel, User user) {
    _state._updateParticipantCount();
  }

  @override
  void onUserExited(OpenChannel channel, User user) {
    _state._updateParticipantCount();
  }
}

class MyConnectionHandler extends ConnectionHandler {
  final OpenChannelPageState _state;

  MyConnectionHandler(this._state);

  @override
  void onConnected(String userId) {}

  @override
  void onDisconnected(String userId) {}

  @override
  void onReconnectStarted() {}

  @override
  void onReconnectSucceeded() {
    _state._initialize();
  }

  @override
  void onReconnectFailed() {}
}
