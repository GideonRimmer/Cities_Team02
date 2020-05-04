// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water_Shader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_Alpha("Alpha", Float) = 1
		_Color("Color", Color) = (1,1,1,0)
		_Speed_MainNoise("Speed_Main/Noise", Vector) = (0,0,0,0)
		_TexPower("TexPower", Float) = 2
		_Speed_Distort("Speed_Distort", Vector) = (0,0,0,0)
		_Distort("Distort", 2D) = "white" {}
		_Float1("Float 1", Float) = 0
		_AddPower("AddPower", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Norm1("Norm1", 2D) = "bump" {}
		_Norm2("Norm2", 2D) = "bump" {}
		_Normal_Power("Normal_Power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		uniform float _Normal_Power;
		uniform sampler2D _Norm1;
		uniform float4 _Speed_MainNoise;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Distort;
		uniform float4 _Speed_Distort;
		uniform float4 _Distort_ST;
		uniform float _Float1;
		uniform sampler2D _Norm2;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _AddPower;
		uniform float _TexPower;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float4 _Color;
		uniform float _Alpha;
		uniform float _Smoothness;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult12 = (float2(_Speed_MainNoise.x , _Speed_MainNoise.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner7 = ( 1.0 * _Time.y * appendResult12 + uv0_MainTex);
			float2 appendResult28 = (float2(_Speed_Distort.x , _Speed_Distort.y));
			float2 uv0_Distort = i.uv_texcoord * _Distort_ST.xy + _Distort_ST.zw;
			float2 panner29 = ( 1.0 * _Time.y * appendResult28 + uv0_Distort);
			float2 appendResult21 = (float2(tex2D( _Distort, panner29 ).rg));
			float2 temp_output_23_0 = ( appendResult21 * _Float1 );
			float4 transform40 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult36 = (float2(transform40.xy));
			float2 temp_output_37_0 = ( ( panner7 + temp_output_23_0 ) + appendResult36 );
			float2 appendResult15 = (float2(_Speed_MainNoise.z , _Speed_MainNoise.w));
			float2 uv0_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner8 = ( 1.0 * _Time.y * appendResult15 + uv0_NoiseTex);
			float2 temp_output_38_0 = ( ( panner8 + temp_output_23_0 ) + appendResult36 );
			float temp_output_60_0 = saturate( ( saturate( saturate( i.vertexColor.r ) ) - ( 1.0 - saturate( ( ( ( tex2D( _MainTex, temp_output_37_0 ).r + tex2D( _NoiseTex, temp_output_38_0 ).r ) / _AddPower ) * _TexPower ) ) ) ) );
			float3 lerpResult82 = lerp( float3(0,0,1) , BlendNormals( UnpackScaleNormal( tex2D( _Norm1, temp_output_37_0 ), _Normal_Power ) , UnpackScaleNormal( tex2D( _Norm2, temp_output_38_0 ), _Normal_Power ) ) , temp_output_60_0);
			o.Normal = lerpResult82;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor115 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( appendResult21 * 0.1 * temp_output_60_0 ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult114 = lerp( screenColor115 , _Color , _Alpha);
			o.Emission = lerpResult114.rgb;
			o.Metallic = 0.0;
			o.Smoothness = _Smoothness;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth119 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth119 = abs( ( screenDepth119 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 10.0 ) );
			o.Alpha = ( temp_output_60_0 * saturate( distanceDepth119 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
254;966;1324;606;889.3128;523.3895;2.2;True;False
Node;AmplifyShaderEditor.Vector4Node;27;-4480.82,656.0263;Inherit;False;Property;_Speed_Distort;Speed_Distort;6;0;Create;True;0;0;False;0;0,0,0,0;0,0.5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-4127.476,663.2414;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-4671.084,255.1947;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;29;-3869.55,415.5963;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;14;-4135.52,-17.30526;Inherit;False;Property;_Speed_MainNoise;Speed_Main/Noise;4;0;Create;True;0;0;False;0;0,0,0,0;0.1,0.3,-0.15,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-3245.105,669.5369;Inherit;True;Property;_Distort;Distort;7;0;Create;True;0;0;False;0;-1;None;06e1f5e73d7915e43b45cbf8afe7c8cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;-2929.281,676.4622;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-3465.548,-103.8063;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-3592.087,-801.7087;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2752.872,1022.23;Inherit;False;Property;_Float1;Float 1;8;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-3246.394,-204.8837;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-3240.71,327.2932;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-2710.978,-245.0314;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2590.307,626.2177;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-2636.323,119.9529;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;40;-3284.584,-947.4448;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;36;-2897.664,-850.5884;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2318.329,-168.8548;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2335.462,153.9716;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2054.293,-144.9779;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2076.14,150.7501;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1920.926,-341.3374;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;-1;None;cdffcc4bc670a3c43953b16ea970d5b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1839.36,110.455;Inherit;True;Property;_NoiseTex;NoiseTex;1;0;Create;True;0;0;False;0;-1;None;5ecdf6185782a0147b1d8313a2b41093;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1088.022,-129.2395;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1057.388,125.6511;Inherit;False;Property;_AddPower;AddPower;9;0;Create;True;0;0;False;0;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-665.1959,436.7906;Inherit;False;Property;_TexPower;TexPower;5;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;56;-663.7387,3.152137;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-432.3871,289.4504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;122;-441.2972,1116.585;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;50;-139.8173,1047.156;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-115.6898,351.2907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;219.1288,525.5867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;-13.28247,902.8981;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;386.8323,951.2407;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;525.3188,628.9207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2296.224,1031.328;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;116;-354.14,35.7794;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-597.5562,543.8748;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1951.151,-789.5489;Inherit;False;Property;_Normal_Power;Normal_Power;13;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;799.9036,678.4742;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;119;1052.904,670.4742;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-1730.189,-1115.675;Inherit;True;Property;_Norm1;Norm1;11;0;Create;True;0;0;False;0;-1;None;de0090fec273e034c957e22731da235b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-35.34009,168.5127;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;80;-1609.214,-696.5811;Inherit;True;Property;_Norm2;Norm2;12;0;Create;True;0;0;False;0;-1;None;a5340b212baeb6843bfcbf98adc8c488;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-199.8536,-140.5535;Inherit;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;1,1,1,0;0.6,0.7647059,0.9607843,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;120;1223.26,594.8916;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;115;131.796,141.3224;Inherit;False;Global;_GrabScreen0;Grab Screen 0;14;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1076.055,-934.2116;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;223.855,364.6075;Inherit;False;Property;_Alpha;Alpha;2;0;Create;True;0;0;False;0;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;83;-541.5853,-434.2082;Inherit;False;Constant;_Vector0;Vector 0;16;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-358.9015,1570.624;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-381.3112,2003.671;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-133.4758,1933.022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;161.7063,2028.759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-101.5018,2115.912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-12.36435,2041.047;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-82.44087,1788.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;82;632.239,-254.2235;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;1209.574,231.7904;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;514.3823,113.9171;Inherit;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;114;834.1563,-87.22241;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;217.8871,1824.872;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;920.6796,196.8374;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;126;379.4326,141.0505;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1530.877,-27.88181;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Water_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;27;1
WireConnection;28;1;27;2
WireConnection;29;0;30;0
WireConnection;29;2;28;0
WireConnection;20;1;29;0
WireConnection;21;0;20;0
WireConnection;12;0;14;1
WireConnection;12;1;14;2
WireConnection;15;0;14;3
WireConnection;15;1;14;4
WireConnection;7;0;9;0
WireConnection;7;2;12;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
WireConnection;8;0;10;0
WireConnection;8;2;15;0
WireConnection;36;0;40;0
WireConnection;25;0;7;0
WireConnection;25;1;23;0
WireConnection;26;0;8;0
WireConnection;26;1;23;0
WireConnection;37;0;25;0
WireConnection;37;1;36;0
WireConnection;38;0;26;0
WireConnection;38;1;36;0
WireConnection;1;1;37;0
WireConnection;2;1;38;0
WireConnection;55;0;1;1
WireConnection;55;1;2;1
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;18;0;56;0
WireConnection;18;1;16;0
WireConnection;50;0;122;1
WireConnection;19;0;18;0
WireConnection;59;0;19;0
WireConnection;75;0;50;0
WireConnection;58;0;75;0
WireConnection;58;1;59;0
WireConnection;60;0;58;0
WireConnection;124;0;21;0
WireConnection;124;1;125;0
WireConnection;124;2;60;0
WireConnection;119;0;118;0
WireConnection;78;1;37;0
WireConnection;78;5;81;0
WireConnection;123;0;116;0
WireConnection;123;1;124;0
WireConnection;80;1;38;0
WireConnection;80;5;81;0
WireConnection;120;0;119;0
WireConnection;115;0;123;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;49;0;43;1
WireConnection;49;1;48;0
WireConnection;52;0;43;2
WireConnection;52;1;48;0
WireConnection;51;0;52;0
WireConnection;51;1;45;0
WireConnection;45;0;49;0
WireConnection;45;1;47;0
WireConnection;44;0;43;1
WireConnection;82;0;83;0
WireConnection;82;1;79;0
WireConnection;82;2;60;0
WireConnection;121;0;60;0
WireConnection;121;1;120;0
WireConnection;114;0;115;0
WireConnection;114;1;6;0
WireConnection;114;2;5;0
WireConnection;47;0;44;0
WireConnection;47;1;48;0
WireConnection;126;0;115;0
WireConnection;0;1;82;0
WireConnection;0;2;114;0
WireConnection;0;3;117;0
WireConnection;0;4;77;0
WireConnection;0;9;121;0
ASEEND*/
//CHKSM=F78C803A1333DEB8A963F4F78428A9A4EBB2AB67