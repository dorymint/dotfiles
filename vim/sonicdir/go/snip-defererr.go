defer func() {
	if err := {{_cursor_}}; err != nil {
		log.Fatal(err)
	}
}()
