import urllib.request
# import http.client
from http import client
import requests
import json
def https():
    # print(r2.read())
    # print(token)
    # conn.close()
    # body1 = '{"username": "admin", "password": "admin"}'
    # headers1 = {"Accept": "application/json, text/plain, */*","Content-Type": "application/json; charset=utf-8"}
    # url = "https://demo-zh.photoprism.app/api/v1/api/v1/session"
    # r = requests.post(url, data=body1, headers=headers1)
    # print(r.status_code)
    # print(r.text)
	# r = requests.post("https://demo-zh.photoprism.app/api/v1/api/v1/session", body=body, headers=headers1)
    # print(r.status_code)
    # print(r.text)
    
    
    # print(r2.headers)
	# # print(r2.getheaders())
    # print(r2.status, r2.reason)
    # url = "https://demo-zh.photoprism.app/api/v1/albums?count=24&offset=0&q=&category=&order=favorites&year=&type=album"
    # r = requests.get(url, headers=header)
    # print("-----------------")
    # print(r.status_code)
    # print(r.text)
    # body = '{"username": "admin", "password": "admin"}'
    # headers1 = {"Accept": "application/json, text/plain, */*","Content-Type": "application/json; charset=utf-8"}
    # r = requests.post("https://demo-zh.photoprism.app/api/v1/api/v1/session", body=body, headers=headers1)
    # print(r.status_code)
    # print(r.text)
    pass


def get_photo_list(token):
    conn = client.HTTPConnection("127.0.0.1:2342")
    header = {
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/json; charset=utf-8",
        "X-Session-Id":token
        }
    # print("/api/v1/photos?count=5&offset=0")
    conn.request("GET", '/api/v1/photos?count=60&offset=0&order=oldest',headers=header)
    r2 = conn.getresponse()
    print(r2.status)
    print(r2.read())
    pass

def login():
    body = '{"username": "haoshuai", "password": "19920105"}'
    conn = client.HTTPConnection("0.0.0.0:2342")
    headers = {"Accept": "application/json, text/plain, */*","Content-Type": "application/json; charset=utf-8"}
    conn.request("POST","/api/v1/session",body.encode('utf-8'),headers=headers)
    r2 = conn.getresponse()
    print(r2.status)
    # print(r2.status, r2.reason)
    token = r2.headers.get('X-Session-Id')
    config = json.loads(r2.read())
    print(config["config"]["downloadToken"])
    downloaded(token=token,downloadToken=config["config"]["downloadToken"])

def upload():
    pass



def downloaded(token,downloadToken):
    conn = client.HTTPConnection("127.0.0.1:2342")
    header = {
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/json; charset=utf-8",
        "X-Session-Id":token
        }
    
    # print("/api/v1/photos?count=5&offset=0")
    # api = "/api/v1/files/5e694de6eea369ba08ecff31ebd902cf9938de99" 获取文件json
    # /api/v1/dl/3cad9168fa6acc5c5c2965ddf6ec465ca42fd818?t=
    # hash = "/3cad9168fa6acc5c5c2965ddf6ec465ca42fd818"
    api = "/api/v1/dl/5e694de6eea369ba08ecff31ebd902cf9938de99?t=" + downloadToken
    conn.request("GET", api,headers=header)
    r2 = conn.getresponse()
    print(r2.status)
    print(r2.read())
    pass

login()

# import base64
# from requests import session
# from requests_toolbelt import MultipartEncoder
# sessions = session()

# with open(file=file_path, mode='rb') as fis:
#     file_content = fis  # base64.b64encode().decode() 有些需要编码
#     files = {
#         'filename': filename,
#         'Content-Disposition': 'form-data;',
#         'Content-Type': 'image/jpeg',
#         'file': (filename, file_content, 'image/jpeg')  
#     }
#     form_data = MultipartEncoder(files)  # 格式转换
#     sessions.headers['Content-Type'] = form_data.content_type
#     response = sessions.post(url=upload_img_url, data=form_data)
