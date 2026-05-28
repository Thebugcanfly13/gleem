import argv
import gleam/io
import gleam/list
import gleam_community/ansi

@external(erlang, "gleem_ffi", "cmd")
fn cmd(command: String) -> String

pub type Answer {
  Yes
  No
}

pub type Task {
  Task(name: String, file: String)
}

pub fn define(tasks: List(Task)) -> List(Task) {
  tasks
}

pub fn run(tasks: List(Task)) {
  case argv.load().arguments {
    [task_name] -> {
      case list.find(tasks, fn(t) { t.name == task_name }) {
        Ok(task) -> run_task(task)
        Error(_) ->
          io.println(
            ansi.red("Error: ")
            <> "Task not defined: "
            <> ansi.magenta(task_name),
          )
      }
    }
    [] -> io.println(ansi.red("Error: ") <> "No task specified.")
    _ -> io.println(ansi.red("Error: ") <> "Too many arguments provided.")
  }
}

fn run_task(task: Task) -> Nil {
  io.println(ansi.pink("Initializing task: ") <> ansi.magenta(task.name))
  let _ = cmd("rm -rf tmp/")
  let _ = cmd("mkdir -p tmp/")
  let _ = cmd("cd tmp && gleam new " <> task.name)
  let _ = cmd("cp gleam.toml tmp/")
  let _ = cmd("cp -r src/build/ tmp/src/")

  let _ =
    cmd(
      "sed -i 's/^name = .*/name = \""
      <> task.name
      <> "\"/' "
      <> "tmp/gleam.toml",
    )
  let _ = cmd("cd tmp && gleam run")
  Nil
}
