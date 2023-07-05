package com.test.tworavel.member;

import lombok.Data;

@Data
public class LandMarkDTO {
	private String lmseq;
	private String lmname;
	private String lmaddress;
	private String lmcontent;
	private String lmcount;
	private String lmlike;
	private String lmfile;
	private String locseq;
	
	private String id;
	private String mseq;
	
	private String olseq;
	private String olcontent;
	private String olcnt;
	
	private String rcnt;
	private String ccnt;
}
