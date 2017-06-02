
func outcha(w *os.File) (chan<- string, <-chan error) {
	ch := make(chan string)
	writed := make(chan error)
	go func() {
		for {
			select {
			//case <-quit:return
			case s := <-ch:
				_, err := fmt.Fprintln(w, s)
				if err != nil {
					writed <- err
					close(ch)
					return
				}
			}
		}
	}()
	return ch, writed
}
