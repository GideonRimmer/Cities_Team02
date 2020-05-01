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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
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
		uniform float _Alpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_output_6_0 = _Color;
			o.Emission = temp_output_6_0.rgb;
			float temp_output_50_0 = saturate( ( ( i.uv_texcoord.y * 2.0 ) * ( ( i.uv_texcoord.x * 2.0 ) * ( ( 1.0 - i.uv_texcoord.x ) * 2.0 ) ) ) );
			float2 appendResult12 = (float2(_Speed_MainNoise.x , _Speed_MainNoise.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner7 = ( 1.0 * _Time.y * appendResult12 + uv0_MainTex);
			float2 appendResult28 = (float2(_Speed_Distort.x , _Speed_Distort.y));
			float2 uv0_Distort = i.uv_texcoord * _Distort_ST.xy + _Distort_ST.zw;
			float2 panner29 = ( 1.0 * _Time.y * appendResult28 + uv0_Distort);
			float4 transform41 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult33 = (float2(transform41.xy));
			float4 tex2DNode20 = tex2D( _Distort, ( panner29 + appendResult33 ) );
			float2 appendResult21 = (float2(tex2DNode20.rg));
			float2 temp_output_23_0 = ( appendResult21 * _Float1 );
			float4 transform40 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 appendResult36 = (float2(transform40.xy));
			float4 tex2DNode1 = tex2D( _MainTex, ( ( panner7 + temp_output_23_0 ) + appendResult36 ) );
			float2 appendResult15 = (float2(_Speed_MainNoise.z , _Speed_MainNoise.w));
			float2 uv0_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner8 = ( 1.0 * _Time.y * appendResult15 + uv0_NoiseTex);
			float4 tex2DNode2 = tex2D( _NoiseTex, ( ( panner8 + temp_output_23_0 ) + appendResult36 ) );
			float temp_output_19_0 = saturate( ( ( ( tex2DNode1.r + tex2DNode2.r ) / _AddPower ) * _TexPower ) );
			o.Alpha = ( saturate( ( saturate( temp_output_50_0 ) - ( 1.0 - temp_output_19_0 ) ) ) * _Alpha );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-786;826;1324;618;961.2709;-1885.629;1.3;True;False
Node;AmplifyShaderEditor.Vector4Node;27;-4480.82,656.0263;Inherit;False;Property;_Speed_Distort;Speed_Distort;7;0;Create;True;0;0;False;0;0,0,0,0;0,0.5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-4158.085,369.6947;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-3922.037,961.5133;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-4127.476,663.2414;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-3869.55,415.5963;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-3401.869,948.0702;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-3472.669,639.8083;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-3245.105,669.5369;Inherit;True;Property;_Distort;Distort;8;0;Create;True;0;0;False;0;-1;None;06e1f5e73d7915e43b45cbf8afe7c8cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;14;-3566.98,82.65786;Inherit;False;Property;_Speed_MainNoise;Speed_Main/Noise;5;0;Create;True;0;0;False;0;0,0,0,0;0.1,0.3,-0.15,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2752.872,1022.23;Inherit;False;Property;_Float1;Float 1;9;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-3101.094,327.2932;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-2929.281,676.4622;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-3225.16,-91.64141;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-3035.642,60.67318;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-3172.684,-395.1714;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-2710.978,-245.0314;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;40;-2868.998,-701.2401;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2590.307,626.2177;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-2815.369,156.6678;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-2517.433,-413.5844;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2365.937,-163.7539;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2421.121,120.1587;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2054.293,-144.9779;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-330.2657,843.1836;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2076.14,150.7501;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1920.926,-341.3374;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;-1;None;cdffcc4bc670a3c43953b16ea970d5b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1839.36,110.455;Inherit;True;Property;_NoiseTex;NoiseTex;1;0;Create;True;0;0;False;0;-1;None;5ecdf6185782a0147b1d8313a2b41093;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;16.27145,1313.607;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-53.80507,1060.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;246.5229,1097.432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;241.5173,837.1481;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1088.022,-129.2395;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1057.388,125.6511;Inherit;False;Property;_AddPower;AddPower;10;0;Create;True;0;0;False;0;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;521.3268,949.3893;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-665.1959,436.7906;Inherit;False;Property;_TexPower;TexPower;6;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;56;-663.7387,3.152137;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;489.3528,766.4996;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-432.3871,289.4504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;784.535,862.2365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;50;1006.07,1014.801;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-115.6898,351.2907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;1587.422,979.0321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;219.1288,525.5867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;470.1223,527.963;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-336.2363,520.5856;Inherit;False;Property;_Alpha;Alpha;2;0;Create;True;0;0;False;0;1;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;833.3684,476.1938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;1258.606,1320.039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;-152.0295,-28.71959;Inherit;False;Property;_Color2;Color2;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-3619.997,1025.906;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;546.6902,1335.458;Inherit;True;Property;_MaskNoise;MaskNoise;11;0;Create;True;0;0;False;0;-1;None;06e1f5e73d7915e43b45cbf8afe7c8cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;227.4815,1367.899;Inherit;False;0;61;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-216.2989,139.0161;Inherit;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;1,1,1,0;0.5655928,0.6877469,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-4027.672,852.9299;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;71;466.5186,1552.527;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1049.364,-393.8458;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;954.4887,1421.181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;828.0964,1575.881;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;368.8176,1669.262;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;67;1105.289,1430.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;544.6155,238.9943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;72;81.64941,1682.705;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;383.6895,1747.098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;328.8783,3.271523;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;63;1437.176,1303.878;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;1577.61,1248.268;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;1063.377,1291.116;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.58;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;76;-472.454,2118.852;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1066.476,-64.68823;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Water_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;27;1
WireConnection;28;1;27;2
WireConnection;29;0;30;0
WireConnection;29;2;28;0
WireConnection;33;0;41;0
WireConnection;31;0;29;0
WireConnection;31;1;33;0
WireConnection;20;1;31;0
WireConnection;15;0;14;3
WireConnection;15;1;14;4
WireConnection;21;0;20;0
WireConnection;12;0;14;1
WireConnection;12;1;14;2
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
WireConnection;44;0;43;1
WireConnection;47;0;44;0
WireConnection;47;1;48;0
WireConnection;49;0;43;1
WireConnection;49;1;48;0
WireConnection;55;0;1;1
WireConnection;55;1;2;1
WireConnection;45;0;49;0
WireConnection;45;1;47;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;52;0;43;2
WireConnection;52;1;48;0
WireConnection;18;0;56;0
WireConnection;18;1;16;0
WireConnection;51;0;52;0
WireConnection;51;1;45;0
WireConnection;50;0;51;0
WireConnection;19;0;18;0
WireConnection;75;0;50;0
WireConnection;59;0;19;0
WireConnection;58;0;75;0
WireConnection;58;1;59;0
WireConnection;60;0;58;0
WireConnection;69;0;68;0
WireConnection;61;1;71;0
WireConnection;71;0;70;0
WireConnection;71;1;73;0
WireConnection;3;0;1;1
WireConnection;3;1;2;1
WireConnection;65;0;20;1
WireConnection;65;1;66;0
WireConnection;73;0;72;0
WireConnection;67;0;65;0
WireConnection;4;0;60;0
WireConnection;4;1;5;0
WireConnection;53;0;54;0
WireConnection;53;1;6;0
WireConnection;53;2;19;0
WireConnection;63;0;67;0
WireConnection;62;0;50;0
WireConnection;62;1;63;0
WireConnection;68;0;61;1
WireConnection;0;2;6;0
WireConnection;0;9;4;0
ASEEND*/
//CHKSM=17F286E6DAD74E2E8C99E8A6F8B758DEE5121FC2