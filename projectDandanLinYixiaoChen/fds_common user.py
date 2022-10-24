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
        return Customer(u, p)


class Customer:
    def __init__(self, username, password):

        self.connection = try_to_connect(username, password)
        self.login_screen()

    def exit(self):
        self.connection.commit()
        self.connection.close()

    def login_screen(self):
        print("----- Welcome to food order system -----\n"
              + "Commands:\n"
                "To exit: exit\n"
                "To create new user: create\n"
                "To login with existing account: login")
        command = input()

        if command.lower() == "login":
            self.user_login()
        elif command.lower() == "create":
            self.create_user()
        elif command.lower() == "exit":
            self.exit()
        else:
            print("----- Invalid command -----")
            self.login_screen()

    def user_login(self):
        username = input("Enter username: ")
        password = input("Enter password: ")
        sql = "select check_username_password('" + username + "','" + password + "') as cust_Id"
        customerId = 1

        try:
            cursor_for_login = self.connection.cursor()
            cursor_for_login.execute(sql)
            result = cursor_for_login.fetchone()
            customerId = result['cust_Id']
            # print(customerId)
            cursor_for_login.close()

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))

        if customerId != 1:
            self.homepage_section(customerId)
        else:
            print("----- invalid combination of input -----\n")
            self.login_screen()

    def create_user(self):
        username = input("Enter username: ")
        sql = '''select check_username('%s') as res''' % username
        check_status = 1
        # print(sql)
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
                cursor_for_create = self.connection.cursor()
                password = input("Enter password: ")
                last_name = input("Last name: ")
                phone_number = input("Default phone number: ")
                default_address = input("Default address: ")
                default_zip = input("Default zip code: ")
                cursor_for_create.callproc("create_newuser",
                                           (username, password, last_name, phone_number, default_address, default_zip))
                # cursor_for_create.close()
                self.connection.commit()
                sql = "select cus_Id as cust_Id FROM customer WHERE user_name = '" + username + "'"
                cursor_for_create = self.connection.cursor()
                cursor_for_create.execute(sql)
                result = cursor_for_create.fetchone()
                customerId = result['cust_Id']
                # cursor_for_fetchId.close()
                cursor_for_create.close()
                self.homepage_section(customerId)

            except pymysql.err.OperationalError as e:
                print('Error: %d: %s' % (e.args[0], e.args[1]))
                self.login_screen()

        else:
            print("----- username already exists -----\n")
            self.login_screen()

    def homepage_section(self, customerId):
        print("----- Welcome to homepage -----\n"
              "user_Id = %d\n" % customerId
              + "Commands:\n"
                "To start an order: order\n"
                "To check order history: history\n"
                "To write a comment: comment\n"
                "To change password: pwd\n"
                "To modify current address: address\n"
                "To exit: exit"
              )
        command = input()

        if command.lower() == "order":
            self.start_order(customerId)
        elif command.lower() == "history":
            self.check_order_history(customerId)
        elif command.lower() == "comment":
            self.write_comment(customerId)
        elif command.lower() == "pwd":
            self.change_password(customerId)
        elif command.lower() == "address":
            self.select_address(customerId, 0)
        elif command.lower() == "exit":
            self.exit()
        else:
            print("----- Invalid command -----")
            self.homepage_section(customerId)

    def change_password(self, customerId):
        old_pwd = input("old password: ")
        new_pwd = input("new password: ")
        try:
            cursor_for_pwd = self.connection.cursor()
            cursor_for_pwd.callproc("change_password", (customerId, old_pwd, new_pwd))
            result = cursor_for_pwd.fetchone()
            # old_pwd = result['pass_word']
            # print("old_pwd: %s" % old_pwd)
            self.connection.commit()
            cursor_for_pwd.close()
            if result['result'] == '0':
                print("----- password successfully updated -----")
                self.homepage_section(customerId)
            else:
                print("----- failed to update your password -----")
                self.homepage_section(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- failed to update your password -----")
            self.homepage_section(customerId)

    def check_order_history(self, customerId):
        print("----- order history: -----")
        try:
            cursor_for_history = self.connection.cursor()
            cursor_for_history.callproc("list_order", (customerId,))
            order_history = cursor_for_history.fetchall()
            for row in order_history:
                print(row)
            cursor_for_history.close()
            self.homepage_section(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.homepage_section(customerId)

    def write_comment(self, customerId):
        try:
            print("----- here are all the orders which you have access to: -----")
            cursor_for_comment = self.connection.cursor()
            cursor_for_comment.callproc("available_to_evaluate", (customerId,))
            result = cursor_for_comment.fetchall()
            cursor_for_comment.close()
            if len(result) == 0:
                print("----- it seems you don't have an access to write a comment right now -----")
                self.homepage_section(customerId)
            else:
                for row in result:
                    print(row)
                try:
                    cursor_for_comment = self.connection.cursor()
                    order_Id = input("please select an order_Id from above to start: ")
                    rating = float(input("give your overall score: "))
                    content = input("write your comment: ")
                    cursor_for_comment.callproc("write_comment", (customerId, order_Id, rating, content))
                    res = cursor_for_comment.fetchone()
                    self.connection.commit()
                    cursor_for_comment.close()
                    related_res_Id = res['result']
                    print(related_res_Id)
                    if related_res_Id != 0:
                        try:
                            cursor_for_comment = self.connection.cursor()
                            cursor_for_comment.callproc("check_recent_comment", (related_res_Id,))
                            result = cursor_for_comment.fetchall()
                            cursor_for_comment.close()
                            print("----- Comments completed -----")
                            print("here are recent comments for the restaurant:")
                            for row in result:
                                print(row)
                            self.homepage_section(customerId)

                        except pymysql.err.OperationalError as e:
                            print('Error: %d: %s' % (e.args[0], e.args[1]))

                    else:
                        print("---- invalid order_Id -----")
                        self.write_comment(customerId)

                except pymysql.err.OperationalError as e:
                    print('Error: %d: %s' % (e.args[0], e.args[1]))
                    print("----- failed to update your comment -----")
                    self.homepage_section(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- it seems you don't have an access to write a comment right now -----")
            self.homepage_section(customerId)

    def start_order(self, customerId):
        print("-----page : start your order ------\n"
              "command:\n"
              "To see restaurant list: res\n"
              "To check comment: view\n"
              "To check menu: menu\n"
              "To start an order: order\n"
              "To exit: back")

        command = input()
        if command.lower() == "order":
            resId = input("----- select a restaurant Id: -----\n")
            # self.show_menu(customerId, resId)
            orderId = 0
            orderId = self.create_order(customerId, resId)
            if orderId == 0:
                self.start_order(customerId)
            else:
                self.order(customerId, resId, orderId)
        elif command.lower() == "res":
            self.list_res(customerId)
        elif command.lower() == "view":
            resId = input("----- select a restaurant Id: -----\n")
            self.view_comment(customerId, resId)
        elif command.lower() == "menu":
            resId = input("----- select a restaurant Id: -----\n")
            self.browse_menu(customerId, resId)
        elif command.lower() == "back":
            self.homepage_section(customerId)
        else:
            print("----- Invalid command -----")
            self.start_order(customerId)

    def list_res(self, customerId):
        print("----- Here are the restaurants available: -----")
        try:
            cursor_for_list_res = self.connection.cursor()
            cursor_for_list_res.callproc("list_restaurant")
            result = cursor_for_list_res.fetchall()
            cursor_for_list_res.close()
            if len(result) == 0:
                print("----- sorry restaurant list not available at this moment -----")
            else:
                for row in result:
                    print(row)
            self.start_order(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- sorry restaurant list not available at this moment -----")
            self.start_order(customerId)

    def view_comment(self, customerId, resId):
        try:
            cursor_for_comment = self.connection.cursor()
            cursor_for_comment.callproc("check_recent_comment", (resId,))
            result = cursor_for_comment.fetchall()
            cursor_for_comment.close()
            if len(result) == 0:
                print("----- sorry, no comment yet -----")
            else:
                for row in result:
                    print(row)
            self.start_order(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- sorry, comment unavailable at this moment -----")
            self.start_order(customerId)

    def browse_menu(self, customerId, resId):
        try:
            cursor_for_menu = self.connection.cursor()
            cursor_for_menu.callproc("Browse_the_menu", (resId,))
            result = cursor_for_menu.fetchall()
            cursor_for_menu.close()
            if len(result) == 0:
                print("----- menu unavailable for selected restaurant -----")
            else:
                for row in result:
                    print(row)
            self.start_order(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- sorry, menu unavailable at this moment -----")
            self.start_order(customerId)

    def show_menu(self, customerId, resId):
        try:
            cursor_for_menu = self.connection.cursor()
            cursor_for_menu.callproc("Browse_the_menu", (resId,))
            result = cursor_for_menu.fetchall()
            cursor_for_menu.close()
            if len(result) == 0:
                print("----- menu unavailable for selected restaurant -----")
                self.start_order(customerId)
            else:
                for row in result:
                    print(row)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- sorry, menu unavailable at this moment -----")
            self.start_order(customerId)

    def order(self, customerId, resId, orderId):
        print("-----page: time to customize your order -----\n"
              "command:\n"
              "To add a cuisine: add\n"
              "To delete cuisine: delete\n"
              "To keep moving forward: address\n"
              "To withdraw order: withdraw")
        command = input()

        if command.lower() == "withdraw":
            self.delete_order(customerId, orderId)
        elif command.lower() == "address":
            self.select_address(customerId, orderId)
        elif command.lower() == "add":
            self.add_cuisine(customerId, resId, orderId)
        elif command.lower() == "delete":
            self.delete_cuisine(customerId, resId, orderId)
        else:
            print("----- Invalid command -----")
            self.order(customerId, resId, orderId)

    def create_order(self, customerId, resId):
        try:
            cursor_for_menu = self.connection.cursor()
            cursor_for_menu.callproc("Browse_the_menu", (resId,))
            result = cursor_for_menu.fetchall()
            cursor_for_menu.close()
            if len(result) == 0:
                print("----- menu unavailable for selected restaurant -----")
                return 0
            else:
                for row in result:
                    print(row)
                try:
                    cursor_for_order = self.connection.cursor()
                    sql = "SELECT create_order(" + str(customerId) + "," + str(resId) + ") as orderId"
                    cursor_for_order.execute(sql)
                    result = cursor_for_order.fetchone()
                    self.connection.commit()
                    cursor_for_order.close()
                    print("----- order number created -----")
                    return result['orderId']

                except pymysql.err.OperationalError as e:
                    print('Error: %d: %s' % (e.args[0], e.args[1]))
                    print("----- unable to create new order at this moment -----")
                    return 0

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- sorry, menu unavailable at this moment -----")
            return 0

    def delete_order(self, customerId, orderId):
        if orderId == 0:
            self.homepage_section(customerId)

        try:
            cursor_for_delete_order = self.connection.cursor()
            sql = "DELETE FROM food_order WHERE order_Id = " + str(orderId) + ""
            cursor_for_delete_order.execute(sql)
            self.connection.commit()
            cursor_for_delete_order.close()
            self.start_order(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- unable to delete order -----")
            self.start_order(customerId)

    def select_address(self, customerId, orderId):
        print("----- page: delivery address -----\n"
              "command:\n"
              "To add new address: add\n"
              "To delete existing address: delete\n"
              "To select one and confirm order: select\n"
              "To withdraw order: withdraw"
              "To go back to home page: home")

        self.browse_address(customerId, orderId)
        command = input()
        if command.lower() == "withdraw":
            self.delete_order(customerId, orderId)
        elif command.lower() == "select":
            addressId = int(input("----- please verify address Id: -----\n"))
            self.confirm_address(customerId, orderId, addressId)
        elif command.lower() == "add":
            self.add_address(customerId, orderId)
        elif command.lower() == "delete":
            self.delete_address(customerId, orderId)
        elif command.lower() == "home":
            self.homepage_section(customerId)
        else:
            print("----- Invalid command -----")
            self.select_address(customerId, orderId)

    def add_address(self, customerId, orderId):
        try:
            new_name = input("please input last name for recipient: ")
            new_number = input("please input call number: ")
            new_address = input("new address: ")
            new_zip = input("zip code: ")
            cursor_for_add_address = self.connection.cursor()
            cursor_for_add_address.callproc("create_new_address",
                                            (customerId, new_name, new_number, new_address, new_zip))
            self.connection.commit()
            cursor_for_add_address.close()
            self.select_address(customerId, orderId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.select_address(customerId, orderId)

    def delete_address(self, customerId, orderId):
        try:
            targetId = int(input("please specify the address Id to delete: "))
            cursor_for_delete_address = self.connection.cursor()
            cursor_for_delete_address.callproc("delete_current_address", (customerId, targetId))
            self.connection.commit()
            cursor_for_delete_address.close()
            self.select_address(customerId, orderId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.select_address(customerId, orderId)

    def browse_address(self, customerId, orderId):
        try:
            cursor_for_address = self.connection.cursor()
            cursor_for_address.callproc("check_deliver_address", (customerId,))
            result = cursor_for_address.fetchall()
            print("----- current address stored in the system: -----")
            cursor_for_address.close()
            for row in result:
                print(row)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.select_address(customerId, orderId)

    def confirm_address(self, customerId, orderId, addressId):
        if orderId == 0:
            self.homepage_section(customerId)

        try:
            cursor_to_confirm_address = self.connection.cursor()
            cursor_to_confirm_address.callproc("user_select_address", (orderId, addressId))
            self.connection.commit()
            cursor_to_confirm_address.close()
            self.confirm_order(customerId, orderId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.select_address(customerId, orderId)

    def confirm_order(self, customerId, orderId):
        try:
            cursor_for_confirm = self.connection.cursor()
            cursor_for_confirm.callproc("user_confirm_order", (orderId,))
            result = cursor_for_confirm.fetchone()
            print("----- order submitted -----")
            print(result)
            self.connection.commit()
            cursor_for_confirm.close()
            self.homepage_section(customerId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            self.select_address(customerId, orderId)

    def add_cuisine(self, customerId, resId, orderId):
        try:
            cuisineId = int(input("please specify the cuisine Id to add: "))
            quantity = int(input("please specify the quantity of selected cuisine: "))
            cursor_for_add_cuisine = self.connection.cursor()
            cursor_for_add_cuisine.callproc("add_cuisine", (orderId, cuisineId, quantity, resId,))
            result = cursor_for_add_cuisine.fetchall()
            self.connection.commit()
            cursor_for_add_cuisine.close()
            print("----- current items in cart: -----")
            for row in result:
                print(row)
            self.order(customerId, resId, orderId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- failed to add cuisine -----")
            self.order(customerId, resId, orderId)

    def delete_cuisine(self, customerId, resId, orderId):
        try:
            cuisineId = int(input("please specify the cuisine Id to delete: "))
            # quantity = int(input("please specify the quantity of selected cuisine: "))
            cursor_for_add_cuisine = self.connection.cursor()
            cursor_for_add_cuisine.callproc("delete_cuisine", (orderId, cuisineId, resId))
            result = cursor_for_add_cuisine.fetchall()
            self.connection.commit()
            cursor_for_add_cuisine.close()
            print("----- current items in cart: -----")
            for row in result:
                print(row)
            self.order(customerId, resId, orderId)

        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            print("----- failed to delete cuisine -----")
            self.order(customerId, resId, orderId)


# test comment for commit
customer = enter()
