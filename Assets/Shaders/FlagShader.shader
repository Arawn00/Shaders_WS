Shader "Custom/FlagShader"
{
   Properties
   {
       _Color("Main Color",Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}
       _Frequency("Frequency",float) = 10
       _Amplitude("Amplitude",float) = 0.15
       _Speed("Speed",float) = 0.5


   }
   SubShader
   {
       Blend SrcAlpha OneMinusSrcAlpha
      Tags
       {
           "Order" = "Transparent"
           "RenderType" = "Transparent"
           "IgnoreProjector" = "True"
       }
       Pass
       {
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           

            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Speed ;
            uniform float _Frequency;
            uniform float _Amplitude;
            struct VertexInput
        {
            float4 vertex: POSITION;
            float4 texcoord: TEXCOORD0;
        };

            struct VertexOutput
        {
            float4 pos: SV_POSITION;
             float4 texcoord: TEXCOORD0;
        };

        float4 vertexAnimFlag(float4 vertPos,float2 uv)
        {
            vertPos.z = vertPos.z + sin((uv.x-_Time.y*_Speed)*_Frequency)*(uv.x*_Amplitude);
            return vertPos;
        }
            VertexOutput vert(VertexInput v)
            {
            VertexOutput o;
            v.vertex = vertexAnimFlag(v.vertex,v.texcoord);

            o.pos = UnityObjectToClipPos(v.vertex);
            o.texcoord.xy = (v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw);
            return o;
            }

         half4 frag(VertexOutput i ): COLOR 
            {
                float4 color = tex2D(_MainTex,i.texcoord)*_Color;
                //color.a = drawCircleAnimate(i.texcoord,_Center,Radius,_Feather);
                return color;

            }
           ENDCG
  
        }
   }
}
