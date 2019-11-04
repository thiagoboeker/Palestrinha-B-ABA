package main

import (
	"fmt"
)

type Pato interface {
	TemAsa() bool
	AndaComoPato() bool
	FazQuack() bool
}

// Patinho é um tipo de pato
type Patinho struct {
	Nome string
}

// TemAsa Checa se tem asa
func (p *Patinho) TemAsa() bool {
	return true
}

// AndaComoPato Checa se anda como pato
func (p *Patinho) AndaComoPato() bool {
	return true
}

// FazQuack Checa se faz quack
func (p *Patinho) FazQuack() bool {
	return true
}

// QuackQuack Faz quack quack
func QuackQuack(p Pato) {
	if p.AndaComoPato() && p.FazQuack() && p.TemAsa() {
		fmt.Println("Quack Quack!")
	}
}

func main() {
	patito := Patinho{Nome: "Feio"}
	QuackQuack(&patito)
}
