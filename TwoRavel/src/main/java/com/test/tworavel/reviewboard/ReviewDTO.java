package com.test.tworavel.reviewboard;

import lombok.Data;

@Data
public class ReviewDTO {
   
   // 후기
   private String rseq;
   private String rcontent;
   private String rcount;
   private String rfile;
   private String rctitle;
   private String msseq;
   
   //댓글
   private String rcseq;
   private String rthread;
   private String rdepth;
   private String rccontent;
   private String rccount;
   
   private String mseq;
   private String id;
   
   private String pseq;
   private String localname;
   private String ptheme;
   
   //해시태그
   private String hseq;
   private String hname;

   //후기해시태그
   private String rhseq;

   
   
   
}