// simple confirm
func confirm(msg string) bool {
	fmt.Print(msg + " [yes:no]?>")
	for sc, i := bufio.NewScanner(os.Stdin), 0; sc.Scan() && i < 2; i++ {
		if sc.Err() != nil {
			log.Fatal(sc.Err())
		}
		switch sc.Text() {
		case "yes", "y":
			return true
		case "no", "n":
			return false
		default:
			fmt.Println(sc.Text())
			fmt.Print(msg + " [yes:no]?>")
		}
	}
	return false
}
