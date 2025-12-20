use std::io;

use crossterm::event::DisableMouseCapture;
use crossterm::event::EnableMouseCapture;
use crossterm::event::Event;
use crossterm::event::KeyCode;
use crossterm::event::KeyModifiers;
use crossterm::event::{self};
use crossterm::execute;
use crossterm::terminal::EnterAlternateScreen;
use crossterm::terminal::LeaveAlternateScreen;
use crossterm::terminal::disable_raw_mode;
use crossterm::terminal::enable_raw_mode;
use ratatui::Terminal;
use ratatui::backend::CrosstermBackend;
use ratatui::layout::Constraint;
use ratatui::layout::Direction;
use ratatui::layout::Layout;
use ratatui::prelude::Stylize;
use ratatui::style::Color;
use ratatui::style::Modifier;
use ratatui::style::Style;
use ratatui::text::Line;
use ratatui::text::Span;
use ratatui::widgets::Block;
use ratatui::widgets::Borders;
use ratatui::widgets::List;
use ratatui::widgets::ListItem;
use ratatui::widgets::Paragraph;
use ratatui::symbols::border::Set;
use ratatui::symbols::border::PLAIN;

#[derive(Clone)]
struct Task {
    name: String,
    completed: bool,
}

enum InputMode {
    Normal,
    Adding,
}

#[derive(PartialEq, Clone, Copy)]
enum View {
    Today,
    Areas,
    Projects,
}

struct App {
    tasks: Vec<Task>,
    selected: usize,
    mode: InputMode,
    input: String,
    current_view: View,
}

impl App {
    fn new() -> App {
        App {
            tasks: vec![
                Task {
                    name: "Press 'a' to add a task".to_string(),
                    completed: false,
                },
                Task {
                    name: "Press Space to toggle completion".to_string(),
                    completed: false,
                },
                Task {
                    name: "Press Ctrl+Up/Down to move tasks".to_string(),
                    completed: false,
                },
            ],
            selected: 0,
            mode: InputMode::Normal,
            input: String::new(),
            current_view: View::Today,
        }
    }

    fn move_up(&mut self) {
        if self.selected > 0 {
            self.selected -= 1;
        }
    }

    fn move_down(&mut self) {
        if self.selected < self.tasks.len().saturating_sub(1) {
            self.selected += 1;
        }
    }

    fn toggle_completion(&mut self) {
        if self.selected < self.tasks.len() {
            self.tasks[self.selected].completed = !self.tasks[self.selected].completed;
        }
    }

    fn move_task_up(&mut self) {
        if self.selected > 0 && self.selected < self.tasks.len() {
            self.tasks.swap(self.selected, self.selected - 1);
            self.selected -= 1;
        }
    }

    fn move_task_down(&mut self) {
        if self.selected < self.tasks.len().saturating_sub(1) {
            self.tasks.swap(self.selected, self.selected + 1);
            self.selected += 1;
        }
    }

    fn add_task(&mut self) {
        if !self.input.is_empty() {
            self.tasks.push(Task {
                name: self.input.clone(),
                completed: false,
            });
            self.input.clear();
            self.selected = self.tasks.len() - 1;
        }
        self.mode = InputMode::Normal;
    }
}

fn main() -> Result<(), io::Error> {
    // Setup terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen, EnableMouseCapture)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    // Create app and run it
    let app = App::new();
    let res = run_app(&mut terminal, app);

    // Restore terminal
    disable_raw_mode()?;
    execute!(
        terminal.backend_mut(),
        LeaveAlternateScreen,
        DisableMouseCapture
    )?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("{:?}", err)
    }

    Ok(())
}

fn run_app<B: ratatui::backend::Backend>(
    terminal: &mut Terminal<B>,
    mut app: App,
) -> io::Result<()> {
    loop {
        terminal.draw(|f| ui(f, &app))?;

        if let Event::Key(key) = event::read()? {
            match app.mode {
                InputMode::Normal => match key.code {
                    KeyCode::Char('q') => return Ok(()),
                    KeyCode::Char('a') => {
                        app.mode = InputMode::Adding;
                        app.input.clear();
                    }
                    KeyCode::Char('1') => app.current_view = View::Today,
                    KeyCode::Char('2') => app.current_view = View::Areas,
                    KeyCode::Char('3') => app.current_view = View::Projects,
                    KeyCode::Up => {
                        if key.modifiers.contains(KeyModifiers::CONTROL) {
                            app.move_task_up()
                        } else {
                            app.move_up()
                        }
                    }
                    KeyCode::Down => {
                        if key.modifiers.contains(KeyModifiers::CONTROL) {
                            app.move_task_down()
                        } else {
                            app.move_down()
                        }
                    }
                    KeyCode::Char(' ') => app.toggle_completion(),
                    _ => {}
                },
                InputMode::Adding => match key.code {
                    KeyCode::Enter => app.add_task(),
                    KeyCode::Char(c) => {
                        app.input.push(c);
                    }
                    KeyCode::Backspace => {
                        app.input.pop();
                    }
                    KeyCode::Esc => {
                        app.mode = InputMode::Normal;
                        app.input.clear();
                    }
                    _ => {}
                },
            }
        }
    }
}

fn ui(f: &mut ratatui::Frame, app: &App) {
    let chunks = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Length(1), // Menu bar
            Constraint::Min(0),    // Task list
            Constraint::Length(2), // Modeline
        ])
        .split(f.area());

    // Menu bar
    let menu_items = vec![
        ("Today", View::Today, '1'),
        ("Areas", View::Areas, '2'),
        ("Projects", View::Projects, '3'),
    ];

    let menu_spans: Vec<Span> = menu_items
        .iter()
        .flat_map(|(name, view, key)| {
            let style = if *view == app.current_view {
                Style::default()
                    .fg(Color::Black)
                    .bg(Color::Yellow)
                    .add_modifier(Modifier::BOLD)
            } else {
                Style::default().fg(Color::White)
            };
            vec![
                Span::raw(" "),
                Span::styled(format!("[{}] {}", key, name), style),
                Span::raw(" "),
            ]
        })
        .collect();

    let menu = Paragraph::new(Line::from(menu_spans))
        .block(Block::default().borders(Borders::NONE))
        .bg(Color::Red);

    f.render_widget(menu, chunks[0]);

    // Task list
    let items: Vec<ListItem> = app
        .tasks
        .iter()
        .enumerate()
        .map(|(i, task)| {
            let checkbox = if task.completed { "[✓] " } else { "[ ] " };
            let content = format!("{}{}", checkbox, task.name);
            let style = if i == app.selected {
                Style::default()
                    .fg(Color::Yellow)
                    .add_modifier(Modifier::BOLD)
            } else if task.completed {
                Style::default()
                    .fg(Color::DarkGray)
                    .add_modifier(Modifier::CROSSED_OUT)
            } else {
                Style::default()
            };
            ListItem::new(content).style(style)
        })
        .collect();

    let list = List::new(items).block(Block::default().borders(Borders::NONE));

    f.render_widget(list, chunks[1]);

    // Modeline
    let modeline_text = match app.mode {
        InputMode::Normal => {
            let task_count = app.tasks.len();
            let completed_count = app.tasks.iter().filter(|t| t.completed).count();
            vec![Line::from(vec![
                Span::raw("Normal mode | "),
                Span::styled(
                    format!("{}/{} completed", completed_count, task_count),
                    Style::default().fg(Color::Green),
                ),
            ])]
        }
        InputMode::Adding => vec![Line::from(vec![
            Span::raw("Add task: "),
            Span::styled(&app.input, Style::default().fg(Color::Yellow)),
            Span::styled("█", Style::default().fg(Color::Yellow)),
        ])],
    };

    let modeline = Paragraph::new(modeline_text).block(
        Block::default()
            .borders(Borders::TOP)
            .border_style(Style::default().bg(Color::Red))
            .border_set(Set {
                top_left: "-",
                ..PLAIN
            }),
    );

    f.render_widget(modeline, chunks[2]);
}
