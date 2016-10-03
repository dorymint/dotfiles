func ask() bool {
	fmt.Println("TODO:is ok?")
	fmt.Printf("[yes:no]? >>")
	for sc, i := bufio.NewScanner(os.Stdin), 0;sc.Scan() && i < 2;i++ {
		if sc.Err() != nil {
			// TODO: Countermove
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

