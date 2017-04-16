
func outcha(out io.Writer) chan<- string {
	ch := make(chan string)
	go func() {
		for {
			_, err := fmt.Fprintf(out, "%s\n", <-ch)
			if err != nil {
				close(ch)
				log.Println("outcah:", err, "outchannel closed")
				return
			}
		}
	}()
	return ch
}
