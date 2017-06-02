func client(port string) error {
	conn, err := net.Dial("tcp", port)
	if err != nil {
		return err
	}
	defer conn.Close()

	// do something
	return nil
}
