func ask(s string) bool {
	fmt.Println(s)
	fmt.Printf("[yes:no]? >>")
	for sc, i := bufio.NewScanner(os.Stdin), 0;sc.Scan() && i < 2;i++ {
		if err := sc.Err(); err != nil {
			// TODO: Countermove
			log.Fatal(err)
		}
		switch sc.Text() {
		case "yes": return true
		case "no": return false
		default:
			fmt.Println(sc.Text())
			fmt.Printf("[yes:no]? >>")
		}
	}
	return false
}

