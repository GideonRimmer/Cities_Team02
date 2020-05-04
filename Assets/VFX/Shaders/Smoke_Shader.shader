// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Smoke_Shader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		_Speed_MainNoise("Speed_Main/Noise", Vector) = (0,0,0,0)
		_TexPower("TexPower", Float) = 2
		_Speed_Distort("Speed_Distort", Vector) = (0,0,0,0)
		_Distort("Distort", 2D) = "white" {}
		_Float1("Float 1", Float) = 0
		_AddPower("AddPower", Float) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _Speed_MainNoise;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Distort;
		uniform float4 _Speed_Distort;
		uniform float4 _Distort_ST;
		uniform float _Float1;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _AddPower;
		uniform float _TexPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Alpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _Color.rgb;
			float2 appendResult139 = (float2(_Speed_MainNoise.x , _Speed_MainNoise.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner141 = ( 1.0 * _Time.y * appendResult139 + uv0_MainTex);
			float2 appendResult130 = (float2(_Speed_Distort.x , _Speed_Distort.y));
			float2 uv0_Distort = i.uv_texcoord * _Distort_ST.xy + _Distort_ST.zw;
			float2 panner132 = ( 1.0 * _Time.y * appendResult130 + uv0_Distort);
			float2 appendResult135 = (float2(tex2D( _Distort, panner132 ).rg));
			float2 temp_output_142_0 = ( appendResult135 * _Float1 );
			float4 transform144 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult145 = (float2(transform144.xy));
			float2 appendResult140 = (float2(_Speed_MainNoise.z , _Speed_MainNoise.w));
			float2 uv0_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner143 = ( 1.0 * _Time.y * appendResult140 + uv0_NoiseTex);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth169 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth169 = abs( ( screenDepth169 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 10.0 ) );
			o.Alpha = ( saturate( ( saturate( saturate( i.vertexColor.r ) ) - ( 1.0 - saturate( ( ( ( tex2D( _MainTex, ( ( panner141 + temp_output_142_0 ) + appendResult145 ) ).r + tex2D( _NoiseTex, ( ( panner143 + temp_output_142_0 ) + appendResult145 ) ).r ) / _AddPower ) * _TexPower ) ) ) ) ) * saturate( distanceDepth169 ) * _Alpha );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
128;312;1324;606;81.71179;-288.9945;1.6;True;False
Node;AmplifyShaderEditor.Vector4Node;129;-4425.917,803.4375;Inherit;False;Property;_Speed_Distort;Speed_Distort;5;0;Create;True;0;0;False;0;0,0,0,0;0,0.5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-4616.18,402.606;Inherit;False;0;134;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;130;-4072.573,810.6526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;132;-3814.647,563.0076;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;133;-4080.617,130.1059;Inherit;False;Property;_Speed_MainNoise;Speed_Main/Noise;3;0;Create;True;0;0;False;0;0,0,0,0;0.1,0.3,-0.15,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;134;-3190.202,816.9482;Inherit;True;Property;_Distort;Distort;6;0;Create;True;0;0;False;0;-1;None;06e1f5e73d7915e43b45cbf8afe7c8cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-3408.193,43.6049;Inherit;False;0;151;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;139;-3191.491,-57.47237;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;137;-3537.183,-654.2975;Inherit;False;0;150;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;135;-2874.378,823.8735;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-3185.807,474.7045;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-2697.969,1169.641;Inherit;False;Property;_Float1;Float 1;7;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;144;-3229.681,-800.0336;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;141;-2656.075,-97.62007;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-2535.404,773.6289;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;143;-2581.42,267.3641;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;145;-2842.761,-703.1772;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-2263.426,-21.44356;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;147;-2280.559,301.3828;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-2021.236,298.1614;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;-1999.389,2.433273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;150;-1866.022,-193.9262;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;-1;None;cdffcc4bc670a3c43953b16ea970d5b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;151;-1784.457,257.8662;Inherit;True;Property;_NoiseTex;NoiseTex;1;0;Create;True;0;0;False;0;-1;None;5ecdf6185782a0147b1d8313a2b41093;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-1033.119,18.17168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-1002.485,273.0624;Inherit;False;Property;_AddPower;AddPower;8;0;Create;True;0;0;False;0;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;155;-608.8354,150.5633;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-610.2926,584.2019;Inherit;False;Property;_TexPower;TexPower;4;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-377.4837,436.8617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;157;-386.3939,1263.996;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;158;-84.91388,1194.567;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;159;-60.78638,498.7019;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;854.807,825.8854;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;160;274.0322,672.998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;161;41.62096,1050.309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;169;1107.808,817.8855;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;162;441.7357,1098.652;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;193;639.346,600.3438;Inherit;False;Property;_Alpha;Alpha;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;163;580.2222,776.332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;1278.164,742.3029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;173;945.8677,-246.5334;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;False;0;1,1,1,0;0.6,0.7647059,0.9607843,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;194;1093.805,1139.016;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;1264.478,379.2017;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;195;1417.789,1088.394;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;197;1076.034,980.0551;Inherit;False;DoubleSidedFresnel;-1;;1;77dc912ff36e1164b9eec4d7a6a09a13;0;4;10;COLOR;0,0,1,0;False;7;FLOAT;0;False;6;FLOAT;1.84;False;4;FLOAT;1.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;196;1844.468,975.9799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;128;1530.877,-27.88181;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Smoke_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;130;0;129;1
WireConnection;130;1;129;2
WireConnection;132;0;131;0
WireConnection;132;2;130;0
WireConnection;134;1;132;0
WireConnection;139;0;133;1
WireConnection;139;1;133;2
WireConnection;135;0;134;0
WireConnection;140;0;133;3
WireConnection;140;1;133;4
WireConnection;141;0;137;0
WireConnection;141;2;139;0
WireConnection;142;0;135;0
WireConnection;142;1;138;0
WireConnection;143;0;136;0
WireConnection;143;2;140;0
WireConnection;145;0;144;0
WireConnection;146;0;141;0
WireConnection;146;1;142;0
WireConnection;147;0;143;0
WireConnection;147;1;142;0
WireConnection;149;0;147;0
WireConnection;149;1;145;0
WireConnection;148;0;146;0
WireConnection;148;1;145;0
WireConnection;150;1;148;0
WireConnection;151;1;149;0
WireConnection;152;0;150;1
WireConnection;152;1;151;1
WireConnection;155;0;152;0
WireConnection;155;1;153;0
WireConnection;156;0;155;0
WireConnection;156;1;154;0
WireConnection;158;0;157;1
WireConnection;159;0;156;0
WireConnection;160;0;159;0
WireConnection;161;0;158;0
WireConnection;169;0;168;0
WireConnection;162;0;161;0
WireConnection;162;1;160;0
WireConnection;163;0;162;0
WireConnection;174;0;169;0
WireConnection;187;0;163;0
WireConnection;187;1;174;0
WireConnection;187;2;193;0
WireConnection;195;0;197;0
WireConnection;196;0;195;0
WireConnection;128;2;173;0
WireConnection;128;9;187;0
ASEEND*/
//CHKSM=AC0024BD507F3C1B0EED36B7F1228EF4E8735379