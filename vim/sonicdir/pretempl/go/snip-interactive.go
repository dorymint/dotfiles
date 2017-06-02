// Return do not close channel
func outNew(prefix string) chan<- string {
	ch := make(chan string)
	go func() {
		for {
			fmt.Print(prefix)
			fmt.Println(<-ch)
		}
	}()
	return ch
}
// modify
func modNew(output chan<- string, prefix string) chan<- string {
	inputch := make(chan string)
	go func() {
		for {
			output <- fmt.Sprintf("%v:%v", prefix, <-inputch)
		}
	}()
	return inputch
}
// {Input > Modify > Output}
func interactive() {
	outch := outNew("prefix>")
	ch := modNew(outch, "hello channel")

	for sc := bufio.NewScanner(os.Stdin); sc.Scan(); {
		if sc.Err() != nil {
			log.Fatalf("interactive(): %v", sc.Err())
		}
		switch in := strings.TrimSpace(sc.Text()); in {
		case "exit", "q", ":q", "quit":
			fmt.Println("exit")
			return
		default:
			ch <- sc.Text()
		}
	}
}
