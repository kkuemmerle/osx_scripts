#! /usr/bin/python

import requests
import json
import socket
import re

login_obj = { "email": "servers@instantcheckmate.com", "apikey": "a27557827936c9c2f8299e425314541cbdc4b"}
#login_obj = { "email": "servers@instantcheckmate.com", "apikey": "62a941c81186851b4f287c22b218544ea87c0"}
headers = { "Content-Type":"application/json", "X-Auth-Key":login_obj['apikey'], "X-Auth-Email":login_obj['email'] }

url = "https://api.cloudflare.com/client/v4/"

tcg_zone_id = "348c33db4e3c6bc999bed8bb89c400f3"
instantcheckmate_id = '1bdaa4083929a3a4a010352d915939ae'
truthfinder_id = 'f1353f9edca33fac7ee2546e1b2cec95'

server_name = socket.gethostname()
server_ip = socket.gethostbyname(server_name)
server_parts = re.split('\.', socket.gethostname())

print server_name
print server_ip
print server_parts
def get_zones(headers_obj):
    r = requests.get(url + "/zones?per_page=50", headers=headers_obj)
    r_json=json.loads(r.text)
    zones = [{"zone": r_json['result'][j]['name'], "id": r_json['result'][j]['id']} for j in range(len(r_json['result']))]
    return zones
    
def get_records(zone_id):
    r = requests.get(url + "/zones/" + zone_id + "/dns_records?type=A&per_page=500", headers=headers)
    r_json=json.loads(r.text)
    records = [{"name": r_json['result'][j]['name'], "id": r_json['result'][j]['id']} for j in range(len(r_json['result']))]
    return records

def post_arecord(zone_id, host, ip):
    data = json.dumps({'type': 'A', 'name':host, 'content':ip})
    r = requests.post(url + "/zones/" + zone_id + "/dns_records", data=data,  headers=headers)
    return r

def search_records(zone_id, search_string):
    records = get_records(zone_id)
    found_list = [i for i in records if search_string in i['name']]
    return found_list

def get_zone_hash(zone_list):
    all_zones = get_zones(headers)
    return [i for i in all_zones if i['zone'] in zone_list]

def list_flattener(l1):
    return [item for sublist in l1 for item in sublist] 
## remember the second parameter is the list that the function checks if first list is in.
def not_in_list(l1,l2):
    return [i for i in l1 if i not in l2]    

## Joins hostname to list of domains; makes a list if a string;
def join_host_to_zone(l):
    if type(l) is str:
        l = [l]
    return ['.'.join([server_parts[0],i]) for i in l]

def add_all_subdomains(l):
    if type(l) is str:
        l = [l]    
    return ['.'.join(['*',i]) for i in l] + l

## build object with hostname zone_id
def build_name_obj(full_names):
    split_names = [i.split('.') for i in full_names]
    domain_names = ['.'.join(i[-2:]) for i in split_names]
    comb_list = [{'host':i[0],'zone':i[1]} for i in zip(full_names,domain_names)]
    for i in range(len(comb_list)):
        if comb_list[i]['zone'] == 'instantcheckmate.com':
            comb_list[i]['id'] = '1bdaa4083929a3a4a010352d915939ae'
        elif comb_list[i]['zone'] == 'truthfinder.com':
            comb_list[i]['id'] = 'f1353f9edca33fac7ee2546e1b2cec95'
    return comb_list

## building the fdqn for records we want to search in Cloudflare
fqdn = join_host_to_zone(['instantcheckmate.com','truthfinder.com'])
a_records_to_search = add_all_subdomains(fqdn)

## Grabbing all DNS records for the zones we want and searching all records for hostname.  We then flatten all sublists into one big list.  
zones_we_want = get_zone_hash(['instantcheckmate.com', 'truthfinder.com'])
searched_records = [search_records(i['id'], server_parts[0]) for i in zones_we_want]
names_in_cloudflare = [[j['name'] for j in i] for i in searched_records]
#names_in_cloudflare_flattened = [item for sublist in names_in_cloudflare for item in sublist]
names_in_cloudflare_flattened = list_flattener(names_in_cloudflare)
#[i for i in a_records_to_search if i not in names_in_cloudflare_flattened]
names_not_in_cloud = not_in_list(a_records_to_search, names_in_cloudflare_flattened)

print '\n'
print names_not_in_cloud

if not names_not_in_cloud:
    print 'No names to update'
    exit(0)
else:
    for i in names_not_in_cloud:
        print i

final_list = build_name_obj(names_not_in_cloud)
print final_list        
if final_list:
    for i in final_list:
        post_arecord(i['id'], i['host'], server_ip)
else:
    print "Records are already there.  Nothing Happend."



#if names_not_in_cloud:
#    for i in names_not_in_cloud:
#        ## api_call

#print names_in_cloudflare
#print [name for name in names_we_want if name not in names_in_cloudflare] #[[j['name'] for j in i] for i in searched_records]]
#print [name for name in names_we_want]

#print names_in_cloudflare
#print names_we_want
#for i in names_we_want:
#    for list in names_in_cloudflare:
#        for j in list:
#            if i not in j:
#                print i
