package com.test.tworavel.plan;

import lombok.Data;

@Data
public class TransferDTO {

   private String busseq;
   private String bnum;
   private String bboard;
   private String btime;
   private String bstart;
   private String bend;
   
   private String fseq;
   private String fnum;
   private String fboard;
   private String ftime;
   private String fstart;
   private String fend;
   
   private String trseq;
   private String trnum;
   private String trboard;
   private String trtime;
   private String trstart;
   private String trend;
   
   private String locseq;
   private String locname;
   private String loclat;
   private String loclng;
   private String loccode;
   
   private String splace;
   private String eplace;
   
}