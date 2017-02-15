
// nyan
func handleConnection(conn net.Conn) {
	defer func() {
		log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "DISCONNECT")
		conn.Close()
	}()
	log.Println(conn.LocalAddr(), " | ", conn.RemoteAddr(), "CONNECTED")

	if err := conn.SetDeadline(/* TODO: set deadline */); err != nil {
		log.Println("conn.SetDeadline: ", err)
		return
	}
}

