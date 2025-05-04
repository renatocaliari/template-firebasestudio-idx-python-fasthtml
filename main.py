from fasthtml.common import *
from fastlite import *
from monsterui.all import *
hdrs = Theme.blue.headers()

# FastHTML app setup
app, rt = fast_app(hdrs=hdrs, live=True)

def FooterLinkGroup(title, links):
    # DivVStacked centers and makes title and each link stack vertically
    return DivVStacked(
        H4(title),
        *[A(text, href=f"#{text.lower().replace(' ', '-')}", cls=TextT.muted)  for text in links])

company = ["About", "Blog", "Careers", "Press Kit"]
resource = ["Documentation", "Help Center", "Status", "Contact Sales"]
legal = ["Terms of Service", "Privacy Policy", "Cookie Settings", "Accessibility"]


@rt("/")
def get():
    return Titled(
        DivVStacked(
            H2("Welcome!"),
            P("IDX Template with FastHTML...",cls=TextT.muted),
            DivHStacked(
                DiceBearAvatar("user"), 
                DivVStacked(
                    P("Cali (Renato Caliari)", cls=TextT.lg),
                    P("linkedin.com/in/calirenato82"), 
                    cls=(TextT.muted,TextT.sm)
                )
            ),
        ),
        Container(cls='uk-background-muted py-12')(Div(
        # Company Name and social icons will be on the same row with as much sapce between as possible
        DivFullySpaced( 
            H3("Company Name"),
            DivHStacked(*[UkIcon(icon, cls=TextT.lead) for icon in 
                        ['twitter', 'facebook', 'github', 'linkedin']])),
        DividerLine(),
        DivFullySpaced( # Each child will be spread out as much as possible based on number of children
            FooterLinkGroup("Company",   company),
            FooterLinkGroup("Resources", resource),
            FooterLinkGroup("Legal",     legal)), 
        DividerLine(),
        P("© Company Name. All rights reserved.", cls=TextT.lead+TextT.sm),
        cls='space-y-8 p-8'))
    )


# if __name__ == "__main__":
#     port = int(os.environ.get("PORT", 5001))
#     serve(port=port)