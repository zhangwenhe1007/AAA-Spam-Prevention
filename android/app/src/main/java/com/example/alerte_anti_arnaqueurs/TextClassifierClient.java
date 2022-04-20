/*
A few notes on the model itself:

HELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
*/


//ok i need to import the package that i declared in build.gradle
//then i can use the tflite functions of the BERTNLClassifier.java file that is on the github page!
    //https://github.com/tensorflow/tflite-support/blob/master/tensorflow_lite_support/java/src/java/org/tensorflow/lite/task/text/nlclassifier/BertNLClassifier.java

package com.example.alerte_anti_arnaqueurs;

//this is basically the path to the source file that i have pasted the link up there
import org.tensorflow.lite.task.text.nlclassifier.BertNLClassifier;

//then, i imported another object from the bertnlclassifier class
    //https://github.com/tensorflow/tflite-support/blob/master/tensorflow_lite_support/java/src/java/org/tensorflow/lite/task/core/BaseOptions.java
import org.tensorflow.lite.task.text.nlclassifier.BertNLClassifier.BertNLClassifierOptions;

import org.tensorflow.lite.task.core.BaseOptions;

import android.content.Context;
import android.util.Log;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.tensorflow.lite.support.label.Category;



public class TextClassifierClient{
    //this is just the name i gave to my APi
    private static final String TAG = "TaskApi";

    public static final String MODELFILE = "model.tflite";

    //i am declaring a global variable that will be my classifier
    BertNLClassifier classifier;

    //this is basically the android context
        //https://www.geeksforgeeks.org/what-is-context-in-android/
    private final Context context;
    
    // constructor class:
    public TextClassifierClient(Context contextGiven){
        this.context = contextGiven;
    }
    
    // //this is the intialization method, that I call before i start my code
    // public void load(){
    //     //I used a try and except thing, so that my code still runs, even though there is an error, so that i can see
    //     try{
    //         BertNLClassifierOptions options =
    //     BertNLClassifierOptions.builder()
    //         //Ok, i gotta go check in another files what the base options are
    //             //there is another file that contains the base options
    //         .setBaseOptions(BaseOptions.builder().setNumThreads(4).build())
    //         .build();

    //     //here, I am declaring the options of my classifier
    //     classifier =
    //         BertNLClassifier.createFromFileAndOptions(context, MODELFILE, options);
    //     } catch(IOException e){
    //         Log.e(TAG, e.getMessage());
    //     }
    // }

//this is the same code as before, without the different options, as it might uselessly increase the power needed to run
   //BEFORE CLASSIFYING YOU HAVE TO LOAD THE MODEL!
    public void load(){
        try{
        classifier =
            BertNLClassifier.createFromFile(context, MODELFILE);
        } catch(IOException e){
            Log.e(TAG, e.getMessage());
        }
    }

    //this method is used to close the program
    public void unload(){
        classifier.close();
        classifier = null;
    }

    // public List<Result> classify(String text) {
    //     //run inference
    //     List<Category> apiResults = classifier.classify(text);
    //     //transforming the inference into usable result
    //     List<Result> results = new ArrayList<>(apiResults.size());
    //     for (int i = 0; i < apiResults.size(); i++) {
    //       Category category = apiResults.get(i);
    //       results.add(new Result("" + i, category.getLabel(), category.getScore()));
    //     }
    //     Collections.sort(results);
    //     return results;
    //   }
    // }

    public List<Category> predicting(String input){
        // Run inference
        System.out.println("hiii");
        System.out.println(input);
        List<Category> results = classifier.classify(input);

        //printing the elements in the list:
        for(int i = 0; i<results.size(); i++){         
            //here I am just printing the label (spam or ham)
            System.out.println(results.get(i).getLabel());
        }
        // log.debug(results);
        return results;
    }

/*the following is just for a test*/
    // public static void main(String[] args){
        
    //     TextClassifierClient test = new TextClassifierClient("hi! This is James, do you remember me?");
    //     List<Category> test_run = test.predicting();
    //     log.debug(test_run);
    // }
    
    
}