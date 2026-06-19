public class Hello : Gtk.Application {
  public Hello() {
    Object(application_id: "me.borretti.Hello");
  }

  public override void activate() {
    var win = new Gtk.ApplicationWindow(this);
    win.set_title("Hello");
    win.set_default_size(256, 128);

    var btn = new Gtk.Button.with_label("Hello, world!");
    btn.clicked.connect(win.close);

    win.child = btn;
    win.present();
  }

  public static int main(string[] args) {
    var app = new Hello();
    return app.run(args);
  }
}
