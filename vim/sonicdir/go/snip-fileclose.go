defer func() {
	if err := {{_cursor_}}file.Close(); err != nil {
		log.Fatal(err)
	}
}()
