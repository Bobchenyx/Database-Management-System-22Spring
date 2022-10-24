#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pymysql


def try_to_connect(user_name, pass_word):
    try:
        cnx = pymysql.connect(host='localhost',
                              user=user_name,
                              password=pass_word,
                              db='foodordersystem',
                              charset='utf8mb4',
                              cursorclass=pymysql.cursors.DictCursor)
        return cnx

    except pymysql.err.OperationalError as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))
        return None


def enter():
    print("---please login MYSQL server with your username and password---")
    u = input("Enter username: ")
    p = input("Enter password: ")
    # u = 'root'
    # p = 'Cyx990831#'
    if try_to_connect(u, p) is None:
        return enter()
    else:
        return Manage(u, p)


class Manage:
    def __init__(self, username, password):
        self.connection = try_to_connect(username, password)
        self.login_screen()

    def exit(self):
        self.connection.commit()
        self.connection.close()

    def login_screen(self):
        print("----- Page: restaurant manage system -----\n"
              + "Commands:\n"
                "To exit: exit\n"
                "To create new user: create\n"
                "To login with existing account: login")
        command = input()

        if command.lower() == "login":
            self.res_login()
        elif command.lower() == "create":
            self.create_res()
        elif command.lower() == "exit":
            self.exit()
        else:
            print("----- Invalid command -----")
            self.login_screen()

    def res_login(self):
        # 1. 此处需要检查商家用户名和密码的sql function
        username = input("Enter username: ")
        password = input("Enter password: ")
        # 添加select对象
        sql = "select res_check_username_password('" + username + "','" + password + "') as res_id"
        res_id = 0

        try:
            cursor_for_login = self.connection.cursor()
            cursor_for_login.execute(sql)
            result = cursor_for_login.fetchone()
            res_id = result['res_id']
            cursor_for_login.close()

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))

        if res_id != 1:
            self.homepage_restaurant(res_id)
        else:
            print("----- invalid combination of input -----\n")
            self.login_screen()

    def create_res(self):
        # 2. 此处需要检查用户名是否重复的func
        username = input("username: ")
        # 添加select对象
        sql = '''select res_check_username('%s') as res''' % username
        check_status = 1
        try:
            cursor_for_create = self.connection.cursor()
            cursor_for_create.execute(sql)
            result = cursor_for_create.fetchone()
            check_status = result['res']
            cursor_for_create.close()

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.login_screen()

        # print(result.values())
        if check_status == 0:
            print("time to input basic info:")
            try:
                # 3. 此次需要对应输入和创建有关proc
                cursor_for_create = self.connection.cursor()
                password = input("Enter password: ")
                res_name = input("restaurant name: ")
                cursor_for_create.callproc("res_create_newuser",
                                           (username, password, res_name))
                # cursor_for_create.close()
                self.connection.commit()
                sql = "select res_Id as res_id FROM restaurant WHERE user_name = '" + username + "'"
                cursor_for_create.execute(sql)
                result = cursor_for_create.fetchone()
                res_id = result['res_id']
                cursor_for_create.close()
                self.homepage_restaurant(res_id)

            except pymysql.err.OperationalError as e:
                print('Error: %d: %s' % (e.args[0], e.args[1]))
                self.login_screen()

        else:
            print("----- username already exists -----\n")
            self.login_screen()

    def homepage_restaurant(self, res_id):
        print("res_id: %d" % res_id)
        print("----- Page: restaurant home -----\n"
              + "Commands:\n"
                "To brows order: order\n"
                "To brows comment: comment\n"
                "To brows menu: menu\n"
                "To assign a driver: driver\n"
                "To change password: pwd\n"
                "To exit: exit"
              )
        command = input()

        if command.lower() == "order":
            self.current_order(res_id)
        elif command.lower() == "comment":
            self.browse_comment(res_id)
        elif command.lower() == "menu":
            self.menu_page(res_id)
        elif command.lower() == "driver":
            self.driver_page(res_id)
        elif command.lower() == "pwd":
            self.pwd(res_id)
        elif command.lower() == "exit":
            self.exit()
        else:
            print("----- Invalid command -----")
            self.homepage_restaurant(res_id)

    def pwd(self, res_id):
        old_pwd = input("old password: ")
        new_pwd = input("new password: ")
        try:
            cursor_for_pwd = self.connection.cursor()
            cursor_for_pwd.callproc("res_change_password", (res_id, old_pwd, new_pwd))
            result = cursor_for_pwd.fetchone()
            # old_pwd = result['pass_word']
            # print("old_pwd: %s" % old_pwd)
            self.connection.commit()
            cursor_for_pwd.close()
            if result['result'] == '0':
                print("----- password successfully updated -----")
                self.homepage_restaurant(res_id)
            else:
                print("----- failed to update your password -----")
                self.homepage_restaurant(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- failed to update your password -----")
            self.homepage_restaurant(res_id)

    def current_order(self, res_id):
        try:
            # 4. 此处需要写proc 查询未完成订单
            cursor_for_order = self.connection.cursor()
            cursor_for_order.callproc("res_check_order", (res_id, ))
            result = cursor_for_order.fetchall()
            cursor_for_order.close()
            print("----- order submitted by user -----")
            if len(result) == 0:
                print("no order needs action right now, jump back to homepage")
                self.homepage_restaurant(res_id)
            else:
                for row in result:
                    print(row)
                try:
                    # 10. 此处需要proc 显示所选订单信息
                    order_id = input("please select the order id which you would like to see more details")
                    cursor_for_order_detail = self.connection.cursor()
                    cursor_for_order_detail.callproc("load_cart", (order_id, ))
                    result = cursor_for_order_detail.fetchone()
                    cursor_for_order_detail.close()
                    print(result)
                    self.homepage_restaurant(res_id)

                except pymysql.err.OperationalError as e:
                    print('Error: %d: %s' % (e.args[0], e.args[1]))
                    self.homepage_restaurant(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.homepage_restaurant(res_id)

    def browse_comment(self, res_id):
        try:
            # 5. 此处需要写proc 查询近期comment
            cursor_for_comment = self.connection.cursor()
            cursor_for_comment.callproc("check_recent_comment", (res_id, ))
            result = cursor_for_comment.fetchall()
            cursor_for_comment.close()
            if len(result) == 0:
                print("----- no comments yet -----")
            else:
                print("----- recent comment -----")
                for row in result:
                    print(row)
            self.homepage_restaurant(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.homepage_restaurant(res_id)

    def menu_page(self, res_id):
        print("----- Page: menu -----")
        self.current_menu(res_id)
        print("command:\n"
              "To add new cuisine: add\n"
              "To delete existing cuisine: delete \n"
              "To go back to homepage: home")

        command = input()
        if command.lower() == "add":
            self.add_cuisine(res_id)
        elif command.lower() == "delete":
            self.delete_cuisine(res_id)
        elif command.lower() == "home":
            self.homepage_restaurant(res_id)
        else:
            print("----- Invalid command -----")
            self.menu_page(res_id)

    def current_menu(self, res_id):
        try:
            # 6. 此处需要添加proc 加载当前商户菜单
            cursor_for_menu = self.connection.cursor()
            cursor_for_menu.callproc("Browse_the_menu", (res_id, ))
            result = cursor_for_menu.fetchall()
            cursor_for_menu.close()
            print("----- current menu -----")
            for row in result:
                print(row)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.menu_page(res_id)

    def add_cuisine(self, res_id):
        try:
            # 7. 此处需要proc 添加新菜品
            cursor_for_add_cuisine = self.connection.cursor()
            cuisine_name = input("cuisine name: ")
            unit_price = float(input("unit price"))
            cursor_for_add_cuisine.callproc("res_add_cuisine", (res_id, cuisine_name, unit_price))
            self.connection.commit()
            cursor_for_add_cuisine.close()
            self.menu_page(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.menu_page(res_id)

    def delete_cuisine(self, res_id):
        try:
            # 8. 此处需要proc 删除已有商品
            cursor_for_delete_cuisine = self.connection.cursor()
            cuisine_id = int(input("cuisine id to delete: "))
            cursor_for_delete_cuisine.callproc("res_delete_cuisine", (res_id, cuisine_id))
            self.connection.commit()
            cursor_for_delete_cuisine.close()
            self.menu_page(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.homepage_restaurant(res_id)

    def driver_page(self, res_id):
        print("-----Page: driver -----")
        print("please choose from the following options:\n"
              "command:\n"
              "To assign a driver to an order: pick\n"
              "To go back to home page: home")

        command = input("")
        if command.lower() == "pick":
            print("----- here are the orders that you could assign driver -----")
            self.order_available(res_id)
            order_id = int(input("----- please select an order id from above: -----"))
            self.list_driver(res_id)
            driver_id = int(input("----- select a driver id from above: -----"))
            self.assign_driver(res_id, order_id, driver_id)
        elif command.lower() == "home":
            self.homepage_restaurant(res_id)
        else:
            print("----- Invalid command -----")
            self.driver_page(res_id)

    def order_available(self, res_id):
        try:
            # 4. 此处需要写proc 查询未完成订单
            cursor_for_order = self.connection.cursor()
            cursor_for_order.callproc("res_check_order", (res_id, ))
            result = cursor_for_order.fetchall()
            cursor_for_order.close()
            if len(result) == 0:
                print("seems no order available yet, jump back to homepage")
                self.homepage_restaurant(res_id)
            else:
                print("----- orders available -----")
                for row in result:
                    print(row)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.driver_page(res_id)

    def list_driver(self, res_id):
        try:
            # 9. 此处需要 proc 加载当前 空闲骑手
            cursor_for_driver_list = self.connection.cursor()
            cursor_for_driver_list.callproc("res_check_rider")
            result = cursor_for_driver_list.fetchall()
            cursor_for_driver_list.close()
            if len(result) == 0:
                print("Sorry, no drivers are free at this moment, jump back to homepage")
                self.homepage_restaurant(res_id)
            else:
                print("----- here are the drivers that are currently free: -----")
                for row in result:
                    print(row)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.driver_page(res_id)

    def assign_driver(self, res_id, order_id, driver_id):
        try:
            # 10.此处需要proc 修改订单状态
            cursor_for_assign_driver = self.connection.cursor()
            cursor_for_assign_driver.callproc("res_assign_driver", (res_id, order_id, driver_id))
            self.connection.commit()
            cursor_for_assign_driver.close()
            self.driver_page(res_id)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.driver_page(res_id)


# test comment for commit
manage = enter()
