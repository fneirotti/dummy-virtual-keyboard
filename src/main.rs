use clap::Parser;
use std::sync::mpsc::channel;
use std::thread;
use std::time::Duration;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Name of virtual keyboard
    name: Option<String>,
}

fn main() {
    let (tx, rx) = channel();

    ctrlc::set_handler(move || tx.send(()).expect("Could not send signal on channel."))
        .expect("Error setting Ctrl-C handler");

    let args = Args::parse();

    let device_name = args
        .name
        .unwrap_or_else(|| "Dummy Virtual Keyboard".to_owned());

    // Create dummy input
    let mut device = uinput::default()
        .unwrap()
        .name(device_name)
        .unwrap()
        .event(uinput::event::Keyboard::All)
        .unwrap()
        .create()
        .unwrap();

    // give kernel a chance to recognize it
    thread::sleep(Duration::from_secs(1));

    rx.recv().expect("Could not receive from channel.");
    println!("Exiting...");
    device.synchronize().unwrap();
}
