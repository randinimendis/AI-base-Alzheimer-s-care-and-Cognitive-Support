import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DoYogaMedScreen extends StatefulWidget {
  final String exName;
  bool? isyoga;
  final String videoUrl;
  DoYogaMedScreen({super.key,required this.exName,required this.isyoga,required this.videoUrl});

  @override
  State<DoYogaMedScreen> createState() => _DoExcersiceScreenState();
}

class _DoExcersiceScreenState extends State<DoYogaMedScreen> {
  List<String>? selectedYogaOrmed;

  List<String> yogaSeatedChair = [
    "Sit tall in a sturdy chair.",
    "Inhale – raise arms overhead.",
    "Exhale – fold forward over legs.",
    "Inhale – lift chest halfway up.",
    "Exhale – fold again.",
    "Inhale – raise arms back up.",
    "Exhale – bring hands to heart."];

  List<String> yogaChairWarrior2 = [
    "Sit sideways on chair.",
    "Front leg bent, back leg extended.",
    "Arms out at shoulder height.",
    "Look over front hand.",
    "Hold, then switch sides.",
  ];

  List<String> yogaAlternateNostril = [
    "Sit calmly.",
    'Close right nostril, inhale left.',
    "Close left, exhale right.",
    "Inhale right, close, exhale left.",
    "Repeat slowly",
  ];

  List<String> yogaStandingChair = [
    "Stand behind chair, hands on backrest.",
    "Inhale – arms up overhead.",
    "Exhale – fold forward, hands to chair.",
    'Inhale – lift chest, flat back.',
    "Exhale – fold again.",
    "Inhale – stand tall, arms up.",
    "Exhale – hands to heart.",
  ];

  List<String> yogaBhastrikaPranayama = [
    "Sit straight.",
    "Inhale deeply through nose.",
    "Forcefully exhale through nose.",
    "Repeat fast, deep breaths (10–20 times).",
    "Rest and breathe normally.",
  ];

  List<String> yogaYogaDown = [
    "Stand facing a chair, hands on backrest.",
    "Walk feet back, bend at hips.",
    "Keep back and arms straight, head between arms.",
    "Hold and breathe.",
    "Slowly return to standing",
  ];


  List<String> mediGratitudeRef = [
  "Sit comfortably and close your eyes.",
  "Take a few deep breaths to relax.",
  "Think of 3 things you are grateful for.",
  "Focus on each one and feel thankful.",
  "Silently say “Thank you” for each.",
  "Stay with this feeling for a few minutes.",
  "Gently open your eyes and smile.",
  ];

  List<String> mediJoyfulVisu = [
  "Sit comfortably and close your eyes.",
  "Breathe deeply and slowly.",
  "Picture a happy moment.",
  "Feel the joy clearly.",
  "Stay in that feeling.",
  "Open your eyes and smile.",

  ];

  List<String> mediDeepBreathing = [
  "Sit comfortably and close your eyes.",
  "Breathe in slowly through your nose.",
  "Breathe out and think: “I am calm.”",
  "Breathe in again.",
  "Breathe out and think: “I am strong.”",
  "Repeat for a few minutes.",
  "Open your eyes and relax.",

  ];

  List<String> mediBodyRelaxing = [
  "Sit or lie down and close your eyes.",
  "Breathe deeply and slowly.",
  'Focus on your feet—relax them.',
  "Move up the body, relaxing each part.",
  "Stay calm and breathe.",
  "Open your eyes gently.",
  ];

  List<String> mediCoolingBreath = [
  'it comfortably.',
  "Inhale through rolled tongue or pursed lips.",
  'Exhale through your nose.',
  "Repeat slowly for a few minutes.",

  ];

  List<String> mediGuideRelaxiation = [
  "Sit or lie down comfortably.",
  "Play a guided audio or app.",
  "Close your eyes and listen.",
  "Follow the voice and relax your body.",
  "Breathe slowly and stay calm.",

  ];

  YoutubePlayerController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      if(widget.isyoga!){
        widget.exName == "Seated Chair Yoga Sun Salutations"?selectedYogaOrmed = yogaSeatedChair:widget.exName == "Alternate Nostril Breathing"?selectedYogaOrmed = yogaAlternateNostril:widget.exName == "Bhastrika Pranayama"?selectedYogaOrmed = yogaBhastrikaPranayama:widget.exName == "Chair Warrior II"?selectedYogaOrmed = yogaChairWarrior2:widget.exName == "Standing Chair Yoga Sun Salutations"?selectedYogaOrmed = yogaStandingChair:selectedYogaOrmed = yogaYogaDown;
      }
    else{
      widget.exName == "Gratitude Reflection Meditation"?selectedYogaOrmed = mediGratitudeRef:widget.exName == "Deep Breathing with Affirmations"?selectedYogaOrmed = mediDeepBreathing:widget.exName == "Cooling Breath"?selectedYogaOrmed = mediCoolingBreath:widget.exName == "Joyful Visualization"?selectedYogaOrmed = mediJoyfulVisu:widget.exName == "Body Relaxation Meditation"?selectedYogaOrmed = mediBodyRelaxing:selectedYogaOrmed = mediGuideRelaxiation;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl)??"",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 246, 1),
        title: Text("${widget.exName}"),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: (){

        },
        builder: (context) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/${widget.exName}.png"),fit: BoxFit.fill)
                  ),
                ),
                showDragHandle: true,
                );
              },
              child: createButton(isShowboarder: true, buttonText: "Show Steps",)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15,top: 15,right: 15,bottom: 2),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(242, 242, 246, 1),
        child:Column(
          children: [
            YoutubePlayer(
              controller: _controller!,
              aspectRatio: 16 / 9,
            ),

            SizedBox(height: 15,),

            Flexible(
              child: ListView.builder(
                itemCount: selectedYogaOrmed?.length??0,
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 1,
                              color: Colors.blue
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: Image.asset("assets/images/yoga 1.png",scale: 4,)),
                          SizedBox(width: 10,),
                          Text("Step ${index+1}: ${selectedYogaOrmed?.elementAt(index)}"??"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12,),),
                        ],
                      ),
                    ),
                  );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText, bool? isLoading}){
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
          border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child:(isLoading??false)?CircularProgressIndicator(color: Colors.white,):Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }
}
