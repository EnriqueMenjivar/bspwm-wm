#!/usr/bin/python3

import imaplib

try:
    FileHandler = open("/home/enrique/.email-credentials","r")
    lines=FileHandler.readlines()
    email=lines[0]
    passw=lines[1]
    FileHandler.close()

    obj = imaplib.IMAP4_SSL('imap.gmail.com','993')
    obj.login(email,passw)
    obj.select()
    print(len(obj.search(None, 'unseen')[1][0].split()))
except:
    print('x')
