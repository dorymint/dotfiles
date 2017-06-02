package client

import (
	"log"
	"net"
)

// Client main process, use tcp
// example: Client(":8080")
// retrun error = net.Dial || dosomething
func Client(port string) error {
	conn, err := net.Dial("tcp", port)
	if err != nil {
		return err
	}
	defer conn.Close()

	if err := dosomething(conn); err != nil {
		return err
	}
	return nil
}

// DO SOMETHING
func dosomething(conn net.Conn) error {
	defer func() {
		log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "DISCONNECT")
		conn.Close()
	}()
	log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "CONNECTED")

	// TODO:
	return nil
}
