
// Listen description
func Listen() error {
	ln, err := net.Listen("tcp", ":TODO PORT No")
	if err != nil {
		return err
	}
	defer ln.Close()

	for {
		if conn, err := ln.Accept(); err != nil {
			log.Println("packagename :Listen(): ", err)
			continue
		}
		go handleConnection(conn) // TODO: make handle function
	}
}

