from http.server import HTTPServer, BaseHTTPRequestHandler
from os import curdir, sep
from RestaurantDatabase import RestaurantDatabase
import cgi

class RestaurantPortalHandler(BaseHTTPRequestHandler):
    
    def __init__(self, *args):
        self.database = RestaurantDatabase()
        BaseHTTPRequestHandler.__init__(self, *args)
    
    def do_POST(self):
        try:
            if self.path == '/addReservation7':
                self.send_response(200)
                self.send_header('Content-type','text/html')
                self.end_headers()
                form = cgi.FieldStorage(
                    fp=self.rfile,
                    headers=self.headers,
                    environ={'REQUEST_METHOD': 'POST'}
                )

                customerID = int(form.getvalue("customerID"))
                reservationTime = form.getvalue("reservationTime")
                numberOfGuests = int(form.getvalue("numberOfGuests"))
                specialRequests = form.getvalue("specialRequests")
                
                # Call the Database Method to add a new reservation
                self.database.addReservation(customerID, reservationTime, numberOfGuests, specialRequests)
                print("Reservation added for customer ID:", customerID)
                
                
                self.wfile.write(b"<html><head><title>Restaurant Portal</title></head>")
                self.wfile.write(b"<body>")
                self.wfile.write(b"<center><h1>Restaurant Portal</h1>")
                self.wfile.write(b"<hr>")
                self.wfile.write(b"<div> <a href='/'>Home</a>| \
                                 <a href='/addReservation'>Add Reservation</a>|\
                                 <a href='/viewReservations'>View Reservations</a></div>|\
                                 <a href='/addCustomer'>Add Customer</a></div>\
                                 ")
                self.wfile.write(b"<hr>")
                self.wfile.write(b"<h3>Reservation has been added</h3>")
                self.wfile.write(b"<div><a href='/addReservation'>Add Another Reservation</a></div>")
                self.wfile.write(b"</center></body></html>")
                
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)

        return
    
    def do_GET(self):
        
        try:
            if self.path == '/':
                data=[]
                records = self.database.getAllReservations()
                print(records)
                data=records
                self.send_response(200)
                self.send_header('Content-type','text/html')
                self.end_headers()
                self.wfile.write(b"<html><head><title>Restaurant Portal</title></head>")
                self.wfile.write(b"<body>")
                self.wfile.write(b"<center><h1>Restaurant Portal</h1>")
                self.wfile.write(b"<hr>")
                self.wfile.write(b"<div> <a href='/'>Home</a>| \
                                 <a href='/addReservation'>Add Reservation</a>|\
                                  <a href='/viewReservations'>View Reservations</a></div>")
                self.wfile.write(b"<hr><h2>All Reservations</h2>")
                self.wfile.write(b"<table border=2> \
                                    <tr><th> Reservation ID </th>\
                                        <th> Customer ID </th>\
                                        <th> Reservation Time </th>\
                                        <th> Number of Guests </th>\
                                        <th> Special Requests </th></tr>")
                for row in data:
                    self.wfile.write(b' <tr> <td>')
                    self.wfile.write(str(row[0]).encode())
                    self.wfile.write(b'</td><td>')
                    self.wfile.write(str(row[1]).encode())
                    self.wfile.write(b'</td><td>')
                    self.wfile.write(str(row[2]).encode())
                    self.wfile.write(b'</td><td>')
                    self.wfile.write(str(row[3]).encode())
                    self.wfile.write(b'</td><td>')
                    self.wfile.write(str(row[4]).encode())
                    self.wfile.write(b'</td></tr>')
                
                self.wfile.write(b"</table></center>")
                self.wfile.write(b"</body></html>")
                return
            if self.path =='/addCustomer':
                return


            if self.path =='/findReservations':
                return
            ## Add any other methods like addSpecialRequests etc
            if self.path =='/addSpecialRequest':
                return

            if self.path =='findReservations':
                return

            if self.path =='deleteReservation':
                return

            if self.path =='searchPreferences':
                return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)

def run(server_class=HTTPServer, handler_class=RestaurantPortalHandler, port=8000):
    server_address = ('localhost', port)
    httpd = server_class(server_address, handler_class)
    print('Starting httpd on port {}'.format(port))
    httpd.serve_forever()

run()
