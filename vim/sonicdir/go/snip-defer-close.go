
// file close
defer func() {
	if errclose := f.Close(); errclose != nil {
		fmt.Fprintf(os.Stderr, {{_cursor_}}":%q\n", errclose)
	}
}()

