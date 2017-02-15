package server

import (
	"log"
	"net"
	"time"
)

func Listen() error {
	ln, err := net.Listen("tcp", ":<PORT NUMBER>")
	if err != nil {
		return err
	}
	defer ln.Close()

	for {
		if conn, err := ln.Accept(); err != nil {
			log.Println("server:Listen(): ", err)
			continue
		} else {
			go handleConnection(conn)
		}
	}
}

func handleConnection(conn net.Conn) {
	defer func() {
		conn.Close()
		log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "DISCONNECT")
	}()

	log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "CONNECT")
	if err := conn.SetDeadline(time.Now().Add(/*TODO: time duration*/)); err != nil {
		log.Println("conn.SetDeadline: ", err)
		return
	}
	// TODO: nyan
}

