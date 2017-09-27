package com.jeffrey.testgradlebuildprofiling;

import android.app.AlertDialog;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = (Button) findViewById(R.id.testButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!AlertDialogUtil.isShowing()) {
                    startActivity(new Intent(MainActivity.this, SecondActivity.class));
                } else {
                    AlertDialogUtil.showDialog(MainActivity.this);
                }
            }
        });
    }
}
