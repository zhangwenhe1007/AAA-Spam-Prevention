//ok i need to import the package that i declared in build.gradle
//then i can use the tflite functions of the BERTNLClassifier.java file that is on the github page!
    //https://github.com/tensorflow/tflite-support/blob/master/tensorflow_lite_support/java/src/java/org/tensorflow/lite/task/text/nlclassifier/BertNLClassifier.java

package tflite;

import android.content.Context;

import java.util.*;

public class TextClassifierClient extends BertNLClassifier{
    
    public static final String MODELFILE = "model.tflite";
    String input;

    //constructor class:
    public TextClassifier(String input_message){
        //ok, am not so sure about the file path
        input = input_message;
    }
    

    public List<Category> predicting(){
        // Initialization
        BertNLClassifierOptions options =
        BertNLClassifierOptions.builder()
            .setBaseOptions(BaseOptions.builder().setNumThreads(4).build())
            .build();
        BertNLClassifier classifier =
        BertNLClassifier.createFromFileAndOptions(context, modelFile, options);

        // Run inference
        List<Category> results = classifier.classify(input);

        //System.out.println(results);
        log.debug(results);
        return results;
    }

/*the following is just for a test*/
    public static void main(String[] args){
        
        TextClassifierClient test = new TextClassifierClient("hi! This is James, do you remember me?");
        List<Category> test_run = test.predicting();
        log.debug(test_run);
    }
    
    
}