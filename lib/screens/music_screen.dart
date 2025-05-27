import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicScreen extends StatefulWidget {
  final String faceType;
  const MusicScreen({super.key,required this.faceType});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 246, 1),
        title: Text("All Songs"),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Container(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromRGBO(242, 242, 246, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Flexible(child: Text(widget.faceType=='Happy'?"Clarence Wijewardena - Malata Bambareku Se":widget.faceType=='Sad'?"Karunaratne Divulgane - Sulanga Numba Wage":"Sunil Perera - Kurumitto",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),)),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          if(widget.faceType=='Happy'){
                            openYouTubeVideo('https://youtu.be/WYf1AUMZ6kk?si=UYiaOSMzCY6sk4aH');
                          }
                          else if(widget.faceType=='Sad'){
                            openYouTubeVideo('https://youtu.be/ob7vS2op4YA?si=aCoKQKzcb9cLC4Fv');
                          }
                          else{
                            openYouTubeVideo('https://youtu.be/w0UDem5KxuM?si=JuR_6Xsu4BMZd7xR');
                          }
                        },
                        child: Icon(Icons.play_circle,size: 50,color: Color.fromRGBO(64, 124, 226, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Flexible(child: Text(widget.faceType=='Happy'?"Sujatha Attanayake - Sanda Gan Iwure":widget.faceType=='Sad'?"TM Jayarathna  - Sanda Wathurak Se":"Deepika Priyadarshani - Senehase nawathane mage lowe",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),)),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          if(widget.faceType=='Happy'){
                            openYouTubeVideo('https://youtu.be/1Grpx0ToyTk?si=2KYtXlK_Jo_5Cffr');
                          }
                          else if(widget.faceType=='Sad'){
                            openYouTubeVideo('https://youtu.be/08_QKR_giVE?si=XgklAu3Im_eZL0yT');
                          }
                          else{
                            openYouTubeVideo('https://youtu.be/5Fb1IdV4GAM?si=Ocn-WqkibRGnUUtn');
                          }
                        },
                          child: Icon(Icons.play_circle,size: 50,color: Color.fromRGBO(64, 124, 226, 1),)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openYouTubeVideo(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // Opens in YouTube app or browser
    } else {
      throw 'Could not launch $videoUrl';
    }
  }
}
