#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pymysql


def main():
    character_name = ''
    print("---please login with your username and password---")
    user_name = input("user_name: ")
    pass_word = input("password: ")

    try:
        cnx = pymysql.connect(host='localhost',
                            user=user_name,
                            password=pass_word,
                            db='lotrfinal_1',
                            charset='utf8mb4',
                            cursorclass=pymysql.cursors.DictCursor)

    except pymysql.err.OperationalError as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))
        return

    cur_cname = cnx.cursor()
    stmt_select = "select character_name from lotr_character order by character_name"

    cur_cname.execute(stmt_select)
    character_exist = cur_cname.fetchall()

    print("please give a character name for following procedure [capitalized first letter]")

    name_check = 1
    while name_check == 1:
        character_name = input("character_name: ")
        for row in character_exist:
            if character_name in row.values():
                name_check = 0
                break
        if name_check == 1:
            print("please make sure your the name you type is in the database")

    try:
        val = ''
        cur_result = cnx.cursor()
        cur_result.callproc("track_character", (character_name, ))

        for row in cur_result:
            print(row)

        cur_result.close()

    except pymysql.Error as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))
        return

    cnx.close()
    return 0


if __name__ == '__main__':
    main()

