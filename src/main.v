module main

import rand
import readline { read_line }

const bannner = "Bienvenue sur le jeux du juste prix\n"

// game engine that store alll needed values
struct Engine {
	// if we start the bot
	bot bool [require]
	// if we want to active the cheat mode
	// NOTE: default on false
	cheat bool
	// top secret option!
	wallhack bool
mut: 
	// actual number to found
	// NOTE: this is mut because of bot mode,
	// cheat mode aswell
	number u32 [require]
	// this is old user input
	user_input u32
	// state is 0 for "moins" and 1 for "plus"
	state u32
	// cheat stat
	cheat_stat u32
	// old user entry
	cheat_old u32
}

fn main() {
	println(bannner)

	// new engine
	mut engine := Engine{
		// random number between 1, 100
		number: rand.u32n(101)!,
		// we decide to use the bot
		bot: false,
		// cheat mode
		cheat: true,
		// default user input to 1000 for the bot mode
		user_input: 1000,
		wallhack: true,
	}

	// play a game
	engine.play()!
}

// play function
pub fn (mut e Engine) play() ! {
	if e.bot {
		// get user input
		e.number = read_line("Entrez un nombre entre 1 et 100 pour le faire deviner au bot: ")!.u32()
	}

	for {
		if !e.bot {
			// get user input
			e.user_input = read_line("Entrez un nombre entre 1 et 100: ")!.u32()
		
		} else {
			// get bot input
			e.user_input = bot_play(mut e)!
			println(e.user_input)
		}

		if e.wallhack {
			println("wallhack: "+e.number.str())
		}
		
		// match user input with number
		match e.number {
			// if its correct
			e.user_input { break }

			// if its not correct and its between 0 and 100...
			0...100 {
				if e.cheat {
					mut diff := u32(0)
					if e.cheat_old > e.user_input {
						diff = e.cheat_old - e.user_input

					} else {
						diff = e.user_input - e.cheat_old
					}

					if e.cheat_stat != 0 {
						e.cheat_stat = u32(int(e.cheat_stat+diff)/2)

					} else {
						e.cheat_stat = diff
					}

					if e.cheat_old == 0 {
						e.cheat_stat = 1
					}

					e.cheat_old = e.user_input
					
					if e.user_input > e.number {
						n := e.number-e.cheat_stat
						if n > 0 {
							e.number = n

						} else {
							if e.number - 1 > 0 {
								//e.number--
								e.number = e.number - 1
							}
						}

						e.state = 0
						println("moins grand")

					} else if e.user_input < e.number {
						n := e.number+e.cheat_stat
						if n < 100 {
							e.number = n

						} else {
							if e.number + 1 < 100 {
								//e.number++
								e.number = e.number + 1
							}
						}

						e.state = 1
						println("plus grand")
					
					} else { break }

				} else {
					if e.user_input > e.number {
						e.state = 0
						println("moins grand")

					} else {
						e.state = 1
						println("plus grand")
					}
				}
			}

			else {}
		}
	}

	if !e.bot {
		println("Trouvé, vous avez gagné! c'etais "+e.number.str())
	
	} else {
		println("Le bot a trouver!")
	}

	return
}

// bot auto play
pub fn bot_play(mut e Engine) !u32 {
	match e.user_input {
		1000 {
			return rand.u32n(101)!
			// if we cannot use rand module
			// we can do:
			// return 50
		}

		else {
			match e.state {
				0 {
					return e.user_input-1
				}

				1 {
					return e.user_input+1
				}


				else {}
			}
		}
	}

	return 0
}