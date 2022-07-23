package main

import "fmt"

func main() {
	x := "Sagar"
	var y *string = &x

	fmt.Println("Name before update: ", x)
	addSurname(y)
	fmt.Println("Name after update: ", x)
}

func addSurname(z *string) {
	*z = (*z) + " Jadhav"
	fmt.Println("Updated name: ", *z)
}
