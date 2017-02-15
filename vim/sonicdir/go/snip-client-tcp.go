// Client main process, use tcp
// example: Client(":8080")
// retrun error = net.Dial
func Client(prot string) error {
	conn, err := net.Dial("tcp", prot)
	if err != nil {
		return err
	}
	defer conn.Close()

	// TODO: do something
	// dosome()
	return nil
}
