Shader "Custom/ColourMixer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            // translating code from https://github.com/DaltonLens/DaltonLens/blob/master/Dalton/OpenGL_Shaders.cpp

            // DaltonLens-Python LMSModel_sRGB_SmithPokorny75.linearRGB_from_LMS
        
            // Derivation of the constant values here can be found in https://github.com/DaltonLens/libDaltonLens
            // and https://github.com/DaltonLens/DaltonLens-Python .
        
            // DaltonLens-Python LMSModel_sRGB_SmithPokorny75.LMS_from_linearRGB
            // Row Major
            float3x3 LMS_from_linearRGB = float3x3(
                1.0, 0.0, 0.0, 
                0.0, 1.0, 0.0,
                0.0, 0.0, 1.0
                // 0.17882, 0.43516, 0.04119,
                // 0.03456, 0.27155, 0.03867,
                // 0.00030, 0.00184, 0.01467
            );
        
            // from Wolfram Alpha (inverse of the above matrix)
            float3x3 linearRGB_from_LMS = float3x3(
                1, 0, 0, 
                0, 1, 0,
                0, 0, 1
                // 8.09504, -13.0514, 11.6745,
                // -1.02498, 5.40209, -11.362,
                // -0.0369831, -0.410662, 69.3527
            );

            // Column Major
            // const float3x3 LMS_from_linearRGB = float3x3(
            //     0.17882, 0.03456, 0.00030,
            //     0.43516, 0.27155, 0.00184,
            //     0.04119, 0.03867, 0.01467
            // );
        
            // // from Wolfram Alpha (inverse of the above matrix)
            // const float3x3 linearRGB_from_LMS = float3x3(
            //     8.09504, -1.02498, -0.0369831,
            //     -13.0514, 5.40209, -0.410662,
            //     11.6745, -11.362, 69.3527
            // );

            float3 LMS_from_RGB(float3 rgb)
            {
                return mul(LMS_from_linearRGB, rgb);
            }

            float3 RGB_from_LMS(float3 lms)
            {
                return mul(linearRGB_from_LMS, lms);
            }

            float3 applyProtanope_Vienot (float3 lms)
            {
                // DaltonLens-Python Simulator_Vienot1999.lms_projection_matrix
                lms[0] = 2.02344*lms[1] - 2.52580*lms[2];
                return lms;
            }
        
            float3 applyDeuteranope_Vienot (float3 lms)
            {
                // DaltonLens-Python Simulator_Vienot1999.lms_projection_matrix
                lms[1] = 0.49421*lms[0] + 1.24827*lms[2];
                return lms;
            }

            float3 applyTritanope_Brettel1997 (float3 lms)
            {
                // See libDaltonLens for the values.
                float3 normalOfSepPlane = float3(0.34478, -0.65518, 0.00000);
                if (dot(lms, normalOfSepPlane) >= 0)
                {
                    // Plane 1 for tritanopia
                    lms.z = -0.00257*lms.x + 0.05366*lms.y;
                }
                else
                {
                    // Plane 2 for tritanopia
                    lms.z = -0.06011*lms.x + 0.16299*lms.y;
                }
                return lms;
            }

            fixed4 frag(v2f_img i) : SV_Target
            {
                fixed4 sRGB = tex2D(_MainTex, i.uv);
                float3 linearCol = float3(GammaToLinearSpaceExact(sRGB.r), GammaToLinearSpaceExact(sRGB.g), GammaToLinearSpaceExact(sRGB.b));
                float3 lms = LMS_from_RGB(linearCol);
                //lms = applyProtanope_Vienot(lms);
                //lms = applyDeuteranope_Vienot(lms);
                //lms = applyTritanope_Brettel1997(lms);
                linearCol = lms;//RGB_from_LMS(lms);
                sRGB.rgb = fixed3(LinearToGammaSpaceExact(linearCol.r), LinearToGammaSpaceExact(linearCol.g), LinearToGammaSpaceExact(linearCol.b));
                return float4(mul(float3x3(1, 0, 0, 0, 1, 0, 0, 0, 1), float3(1, 1, 1)), 1);
            }
            ENDCG
        }
    }
}
