import 'package:OpenForge/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _controller;
    bool _isLoading = true; 
    bool displayAppBar=false;


  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
  
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true; 
              });
            },
          onPageFinished: (String url) {
            print("*************$url");

 setState(() {
                _isLoading = false; 
              });
            if(url.startsWith('https://openforge.gov.in/account/login.php')){
              displayAppBar=true;
              setState(() {
  
});
              loginPageScript();
            }else if(url=='https://openforge.gov.in/plugins/tracker/?tracker=1059&func=new-artifact'){
                 displayAppBar=false;
setState(() {
  
});
            Future.delayed(const Duration(microseconds: 200 ), () {
              _injectJavaScript();
            });
           } },
        ),
      )
      ..loadRequest(Uri.parse(
      'https://openforge.gov.in/plugins/tracker/?tracker=1059&func=new-artifact'
        ));
  }



Future<void> loginPageScript() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
  final String? password = prefs.getString('password');
  final String? location = prefs.getString('location');
  
  print(location);

  try {
    
    
    final String loginScript = '''

    try {
      function setFormValues(username, password) {
        document.getElementById('form_loginname').value = username;
        document.getElementById('form_pw').value = password;
      }

      setFormValues('$username', '$password');
    } catch(e) {
      console.log(e);
    }

    console.log('%%%%%%%%%%%%%%%%%%%%%%%%%');
    ''';

    await _controller.runJavaScript(loginScript);
  } catch (e) {
    print('Error running JavaScript: $e');
  }
}


void _injectJavaScript() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
 
  final String? location = prefs.getString('location');


  try {
    final String jsCode = '''
function selectOptions() {
    console.log('selectOptions function called');
    try {
        const teamMembersDropdown = document.getElementById('tracker_field_34749');
        const attendanceDropdown = document.getElementById('tracker_field_34751');
        const locationDropdown = document.getElementById('tracker_field_37668');
        
        if (!teamMembersDropdown || !attendanceDropdown || !locationDropdown) {
            console.log('Error: One or more dropdowns not found.');
            return;
        }

        const userInfoString = getUserInfoString();
         selectDefaultValueByTitle(userInfoString);
        updateDisplay('tracker_field_34749', userInfoString, userInfoString);

        const attendanceOption = attendanceDropdown.querySelector('option[value="28891"]');
        if (!attendanceOption) {
            console.log('Error: Option for Present not found.');
            return;
        }

        attendanceDropdown.value = '28891';
        updateDisplay('tracker_field_34751', attendanceOption.getAttribute('data-item-id'), 'Present');
        
      
        selectLocation('tracker_field_37668', '$location');
        updateDisplay('tracker_field_37668', '$location', '$location');

        dispatchChangeEvent(teamMembersDropdown);
        dispatchChangeEvent(attendanceDropdown);
        dispatchChangeEvent(locationDropdown);

    } catch (error) {
        console.log('Error in selectOptions function:', error.message);
    }
}

function selectLocation(selectId, title) {
    const selectElement = document.getElementById(selectId);
    if (!selectElement) {
        console.error('Select element not found with ID:');
        return;
    }

    for (let option of selectElement.options) {
        option.removeAttribute('selected');
        if (option.title === title) {
            selectElement.value = option.value;
            option.setAttribute('selected', 'selected');
            dispatchChangeEvent(selectElement);
            break;
        }
    }
}

function dispatchChangeEvent(element) {
    if (element) {
        const event = new Event('change', { bubbles: true });
        element.dispatchEvent(event);
    }
}

function getUserInfoString() {
    var userInfoElement = document.querySelector('#nav-dropdown-user-content .user-infos-names');
    
    var realName = '';
    var loginName = '';
    
    if (userInfoElement) {
        var realNameElement = userInfoElement.querySelector('.user-infos-real-name');
        var loginNameElement = userInfoElement.querySelector('.user-infos-login-name');
        
        if (realNameElement) {
            realName = realNameElement.textContent.trim();
        }
        if (loginNameElement) {
            loginName = loginNameElement.textContent.trim();
            loginName = loginName.substring(1);
        }
    }
    
    return realName + ' (' + loginName + ')';
}

function updateDisplay(selectId, itemId, displayText) {
    console.log(itemId);
    console.log("-----------");

    try {
        const selectElement = document.getElementById(selectId);
        if (!selectElement) {
            console.log('Error: Select element not found for ID: ');
            return;
        }

        const displaySpan = selectElement.closest('.tracker_artifact_field')?.querySelector('.list-picker-selected-value');
        if (!displaySpan) {
            console.log('Error: Display span not found for select element ID:');
            return;
        }

        displaySpan.textContent = displayText;
        displaySpan.setAttribute('data-item-id', itemId);
    } catch (error) {
        console.log('Error in updateDisplay function:', error.message);
    }
}
function selectDefaultValueByTitle(title) {
console.log("///////////////////////////////");
console.log(title);
    const selectElement = document.getElementById('tracker_field_34749');
    
    for (let i = 0; i < selectElement.options.length; i++) {
        const option = selectElement.options[i];
        
        option.removeAttribute('selected');
        
        if (option.title === title) {
            selectElement.value = option.value;
            
            option.setAttribute('selected', 'selected');
            
            const event = new Event('change', { bubbles: true });
            selectElement.dispatchEvent(event);
            
            break;
        }
    }
}
selectOptions();


''';

    // Inject JavaScript into the WebView
    await _controller.runJavaScript(jsCode);
  } catch (e) {
    print('Error injecting JavaScript: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return _isLoading? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Image.asset('assets/openforge_logo.png'),
             const   SizedBox(height: 50,),
             const   CircularProgressIndicator()
              ],),
            ),
          ):
    
    
    Scaffold(
      appBar:displayAppBar? AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: IconButton(onPressed: 
      (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>const LoginScreen()));
      }, icon:const Row(
        children: [
          Icon(Icons.chevron_left),
          Text('Back'),
        ],
      )),):PreferredSize(
        preferredSize:const Size.fromHeight(0), 
        child: Container(), 
      ),
      body:
      
       SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
