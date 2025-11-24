use std::io;
use std::io::Write;
use rand::Rng;
use std::cmp::Ordering;

fn rand_byte() -> u8 {
    let byte: u8 = rand::thread_rng().gen_range(1..=100);
    return byte;
}

fn read_line() -> String {
    let mut intake: String = String::new();
    let stream: io::Stdin = io::stdin();
    stream.read_line(&mut intake).expect("IO failure.");
    intake
}

fn parse_byte(s: String) -> Option<u8> {
    match s.trim().parse() {
        Ok(v) => Some(v),
        Err(_) => None,
    }
}

fn flush_stdout() {
    io::stdout().flush().expect("Error flushing stdout.");
}

fn main() {
    println!("Guess the number!");
    let secret: u8 = rand_byte();
    loop {
        print!("Enter a number: ");
        flush_stdout();
        let guess: u8 = match parse_byte(read_line()) {
            Some(v) => v,
            None => {
                println!("Not an integer.");
                continue
            },
        };
        match guess.cmp(&secret) {
            Ordering::Less => println!("Too low!"),
            Ordering::Greater => println!("Too high!"),
            Ordering::Equal => {
                println!("You win!");
                println!("Your secret was: {secret}.");
                break;
            },
        }
    }
}
