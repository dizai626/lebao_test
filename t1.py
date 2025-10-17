from datetime import datetime
from http.cookiejar import domain_match

import pandas as pd

def parse_nginx_log(line):
    line = line.strip()
    if not line:
        return None

    try:
        ## 1.按照' " ' 引号来分割
        parts = line.split('"')

        ## 2.请求 ip 和时间
        request_ip = parts[0].split(' - - ')[0]
        request_time = datetime.strptime(parts[0].split(' - - ')[1].strip().strip('[]'),"%d/%b/%Y:%H:%M:%S %z") ##  [28/Feb/2019:13:17:10 +0000]

        ## 3.请求信息
        request_info = parts[1].strip()
        request_info_split = request_info.split(' ')
        if(len(request_info_split) >=1):
            request_method=request_info_split[0]
        else:
            request_method=''
        if(len(request_info_split) >=2):
            request_path=request_info_split[1]
        else:
            request_path=''
        if(len(request_info_split) >=2):
            request_protocol=request_info_split[2]
        else:
            request_protocol=''

        ## 4.请求信息
        status_size=parts[2].strip()
        status_size_split=status_size.split(' ')
        if(len(status_size_split) >=1):
            status_code=status_size_split[0]
        else:
            status_code=''
        if(len(status_size_split) >=2):
            body_size=status_size_split[1]
        else:
            body_size=''

        ## 5. Referer
        referer = parts[3].strip()

        ## 5. Referer
        agent_info = parts[5].strip()

        # 返回结构化字典
        return {
            'ip': request_ip,
            'time': request_time,
            'method': request_method,
            'path': request_path,
            'protocol': request_protocol,
            'status': status_code,
            'body_size': body_size,
            'referer': referer,
            'user_agent': agent_info
        }
    except:
        return None


if __name__ == '__main__':
    log_lines = []
    #解析日志文件
    log_file = 'demo.log'
    with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            log_lines.append(line)
    parsed_log_lines = [parse_nginx_log(line) for line in log_lines if parse_nginx_log(line) is not None]
    df=pd.DataFrame(parsed_log_lines)


    ## t1.计算 HTTPS 请求有多少个是以 domain1.com 为域名
    https_requests = df[df['protocol'].str.contains('HTTPS')]
    domain_requests=https_requests[https_requests['referer'].str.contains('domain1.com')]
    print("以 domain1.com 为域名的HTTPS 请求个数:",domain_requests.shape [0])

    ## t2.计算某日期成功比例
    target_date=pd.to_datetime("2019-02-28").date()

    date_requests=df[df["time"].dt.date==target_date]
    sum_cnt=date_requests.shape[0]

    success_requests = date_requests[date_requests['status'] == '200']
    success_cnt = success_requests.shape[0]
    print("当日所有请求中成功的比例:",success_cnt/sum_cnt)





