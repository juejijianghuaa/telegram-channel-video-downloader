import time
from telethon.sync import TelegramClient
from telethon.tl.types import MessageMediaDocument

# ************************************************************
#                       配置信息
# ************************************************************
# 申请并替换为你的 api_id 和 api_hash
#
# 在 my.telegram.org 页面 输入手机号和网页验证码 登录管理后台
# 点击 API development tools 进入 Create new application 页面
# 填写资料点击创建 会生成 api_id api_hash
# 网页点击create application按钮创建时 经常会提示失败
# 没有明确的解决方法 在不同的时段多试几次 有几率就成功了 有时候好几天都不行
api_id = 26183977
api_hash = 'f20004c868bd9e626e6bf815343518ee'

# 定义会话名称，可以随便指定，确保唯一即可
#
# 第一次登录时在控制台需要输入一次手机号
# 然后telegram会给你的网页版发一条验证码消息
# 将验证码输入到控制台 创建session文件
# 有了session文件以后 不要删除 下一次就可以直接启动不需要进行验证了
session = str(api_id) + '_session'

# 消息偏移点 id，表示从哪一条消息开始下载，可以忽略之前已经处理过的消息
offset_id = 318

# 每次查询的消息数量
message_limit = 1
# 想要下载的频道用户名，如果频道地址是 https://t.me/abc，那么频道名称为 "abc"
channel_username = 'PandaGroovePG'
# ************************************************************
#                       配置结束
# ************************************************************


# 创建一个client
client = TelegramClient(session, api_id, api_hash)


def bytes_to_mb(bytes):
    """
    将字节数转换为以 MB 为单位的字符串格式
    """
    mb = bytes / (1024 * 1024)
    return "{:.2f} MB".format(mb)


# 显示下载进度 可以不配置
async def upload_progress_callback(uploaded_bytes, total_bytes):
    """
    上传进度回调函数
    """
    global start_time, previous_uploaded_bytes, previous_time
    current_time = time.time()
    current_uploaded_bytes = uploaded_bytes
    uploaded_since_last_time = current_uploaded_bytes - previous_uploaded_bytes
    time_since_last_time = current_time - previous_time

    if time_since_last_time > 0:
        speed = uploaded_since_last_time / time_since_last_time  # 网速，单位为字节/秒
    else:
        speed = 0

    print('\r\t\t\t\t -- Uploaded', bytes_to_mb(uploaded_bytes), '/', bytes_to_mb(total_bytes),
          ' (', "{:.2f}".format(speed / (1024 * 1024)), 'MB/s )', end='', flush=True)

    previous_uploaded_bytes = current_uploaded_bytes
    previous_time = current_time


async def get_channel_message_count():
    """
    获取频道总消息数量
    """
    global channel_username
    channel_entity = await client.get_entity(channel_username)
    messages = await client.get_messages(channel_entity)
    total_messages = messages.total
    print("当前频道共有消息数量: ", total_messages)


async def download_media():
    """
    获取频道消息，并下载视频消息
    """
    global channel_username
    channel_entity = await client.get_entity(channel_username)

    offset = offset_id
    while True:

        # 每次查询 5 条消息
        # messages = await client.get_messages(channel_entity, limit=message_limit, reverse=True, offset_id=offset)
        messages = await client.get_messages(channel_entity, limit=1, reverse=False)

        print("\n查到消息数量: ", len(messages), '偏移id', offset)
        if not messages:
            break
        for message in messages:
            if message.media and isinstance(message.media,
                                            MessageMediaDocument) and 'zip' in message.media.document.mime_type:

                # 只保留zip
                print("\nmime_type: ", message.media.document.attributes[0].file_name)
                if message.media.document.mime_type != 'application/zip':
                    continue

                file_path = 'files/' + channel_username + "/"

                # 如果是消息组 那么保存到同一个文件夹里
                if message.grouped_id is not None:
                    file_name = f"{message.grouped_id}/{message.id}.zip"
                else:
                    file_name = f"{message.media.document.attributes[0].file_name}.zip"

                file_name = file_path + file_name
                print("\n开始下载: ", file_name)
                await client.download_media(message=message, file=file_name,
                                            progress_callback=upload_progress_callback)
        break
        # # 更新偏移量
        # offset = offset + message_limit


print('starting....')

with client:
    start_time = time.time()
    previous_uploaded_bytes = 0
    previous_time = start_time

    # 获取频道消息数量
    client.loop.run_until_complete(get_channel_message_count())

    # 获取并下载频道消息
    client.loop.run_until_complete(download_media())

print('\ndone....')
