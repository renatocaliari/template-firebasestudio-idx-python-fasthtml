from fasthtml.common import *
from fastlite import *
from monsterui.all import *
hdrs = Theme.blue.headers()

# FastHTML app setup
app, rt = fast_app(hdrs=hdrs, live=True)

@rt("/")
def get():
    return Titled("Welcome",
        Card(
            P("Your first FastHTML + FastLite + MonsterUI app")
        )
    )

if __name__ == "__main__":
    serve()