import {ChatAppProvider} from "../Context/ChatAppContext.js";
import {NavBar} from "../Components/index.js";

const MyApp = ({Components, pageProps}) =>(
    <div>
<ChatAppProvider>
    <NavBar/>
        <Components {...pageProps} />
        </ChatAppProvider>
    </div>
)

export default MyApp;
