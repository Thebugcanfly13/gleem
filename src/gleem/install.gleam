import gleam/io
import gleam_community/ansi

@external(erlang, "io", "get_line")
pub fn get_line(prompt: String) -> String

@external(erlang, "gleem_ffi", "cmd")
fn cmd(command: String) -> String

pub type Answer {
  Yes
  No
}

pub fn ask() -> Answer {
  case get_line("Do you wish to install Gleem? (y/n) ") {
    "y\n" -> Yes
    "n\n" -> No
    _ -> ask()
  }
}

fn install() -> Result(Nil, String) {
  io.println("Downloading Gleem binary and making it executable...")
  let output =
    cmd(
      "curl -L https://github.com/Thebugcanfly13/gleem/releases/latest/download && chmod +x /usr/bin/gleem",
    )
  case output {
    "" -> {
      io.println(ansi.green("Installation successful!"))
      io.println("Thank you for using Gleem!")
      Ok(Nil)
    }
    err -> Error(err)
  }
}

pub fn main() {
  io.println(ansi.pink("Welcome to the Gleem installer!"))
  io.println(
    "Gleem currently only supports Linux systems with the /usr/bin directory.",
  )
  case ask() {
    Yes -> {
      case install() {
        Ok(_) -> ansi.green("Installed binary successfully!")
        Error(err) -> ansi.red("Installation failed: " <> err)
      }
    }
    No -> ansi.red("Installation cancelled.")
  }
  |> io.println()
}
